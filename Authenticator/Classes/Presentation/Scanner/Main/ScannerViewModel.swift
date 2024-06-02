//
//  ScannerViewModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import RxSwift
import RxCocoa
import AVFoundation
import Vision

final class ScannerViewModel {
    private let totpService = TOTPService()
    
    enum OtherMethod {
        case manual
        case photo
        case file
    }
    
    enum Route {
        case detectedToken(TokenModel)
        case wrongQR
        case otherMethod
        case photoLibrary
        case files
        case manual
    }
    
    struct Input {
        let scannedValue: Signal<String>
        let needRecognize: Signal<Void>
        let selectedMethod: Signal<OtherMethod>
        let didTapOtherMethod: Signal<Void>
        let selectedPhoto: Signal<UIImage>
        let selectedFile: Signal<Data>
    }
    
    struct Output {
        let showAlert: Signal<Void>
        let route: Signal<Route>
    }
    
    func configure(input: Input) -> Output {
        var isShowAlert: Bool {
            [.authorized, .notDetermined].contains(AVCaptureDevice.authorizationStatus(for: .video))
        }
        
        let scannedTokenModel = input.needRecognize
            .asObservable()
            .startWith(())
            .flatMapLatest { _ in input.scannedValue.asObservable().take(1) }
            .map { value -> TokenModel? in
                return URL(string: value)
                    .flatMap { TokenModel(from: $0) }
            }
        
        let otherMethodsRoute = input.selectedMethod
            .compactMap { method -> Route? in
                switch method {
                case .manual:
                    return .manual
                case .photo:
                    return .photoLibrary
                case .file:
                    return .files
                }
            }
        
        let photoRecognizeModel = input.selectedPhoto
            .asObservable()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .flatMapLatest { [weak self] image -> Observable<TokenModel?> in
                guard let self else { return .empty() }
                
                return detectQRCode(from: image)
                    .map { value -> TokenModel? in
                        return value
                            .flatMap { URL(string: $0) }
                            .flatMap { TokenModel(from: $0) }
                    }
                    .catchAndReturn(nil)
                    .take(1)
            }
        
        let fileRecognizeModel = input.selectedFile
            .asObservable()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .flatMapLatest { [weak self] data -> Observable<TokenModel?> in
                guard let self else { return .empty() }
                
                return detectQRCode(from: data)
                    .map { value -> TokenModel? in
                        return value
                            .flatMap { URL(string: $0) }
                            .flatMap { TokenModel(from: $0) }
                    }
                    .catchAndReturn(nil)
                    .take(1)
            }
        
        let recognizeRoute = Observable
            .merge(scannedTokenModel, photoRecognizeModel, fileRecognizeModel)
            .map { model -> Route in
                guard let model, !TOTPGenerator.getCode(for: model, with: .init()).isEmpty else { return .wrongQR }
                
                return .detectedToken(model)
            }
            .asSignal(onErrorSignalWith: .empty())
        
        let route = Signal
            .merge(
                recognizeRoute,
                input.didTapOtherMethod.map { _ in .otherMethod },
                otherMethodsRoute
            )
        
        return Output(
            showAlert: .empty(),
            route: route
        )
    }
}

private extension ScannerViewModel {
    func detectQRCode(from image: UIImage) -> Observable<String?> {
        return Observable<String?>.create { observer in
            let defaultError: Error = NSError(domain: "ScannerViewModel", code: -1, userInfo: [:])
            
            if let ciImage = image.cgImage {
                let request = VNDetectBarcodesRequest { request, error in
                    if let result = request.results?.first(where: { $0 is VNBarcodeObservation}) as? VNBarcodeObservation {
                        observer.onNext(result.payloadStringValue)
                        observer.onCompleted()
                    } else {
                        observer.onError(defaultError)
                    }
                }
                
                request.revision = VNDetectBarcodesRequestRevision2
                request.symbologies = [.qr, .dataMatrix, .aztec]
                #if targetEnvironment(simulator)
                request.revision = VNDetectBarcodesRequestRevision1
                #endif
                
                let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
                
                let requestHandler = VNImageRequestHandler(cgImage: ciImage, orientation: cgOrientation)
                do {
                    try requestHandler.perform([request])
                } catch {
                    observer.onError(error)
                }
            } else {
                observer.onError(defaultError)
            }
            
            
            
            return Disposables.create()
        }
    }
    
    func detectQRCode(from data: Data) -> Observable<String?> {
        return Observable<String?>.create { observer in
            let defaultError: Error = NSError(domain: "ScannerViewModel", code: -1, userInfo: [:])
            
            let request = VNDetectBarcodesRequest { request, error in
                if let result = request.results?.first(where: { $0 is VNBarcodeObservation}) as? VNBarcodeObservation {
                    observer.onNext(result.payloadStringValue)
                    observer.onCompleted()
                } else {
                    observer.onError(defaultError)
                }
            }
            
            request.revision = VNDetectBarcodesRequestRevision2
            request.symbologies = [.qr, .dataMatrix, .aztec]
            #if targetEnvironment(simulator)
            request.revision = VNDetectBarcodesRequestRevision1
            #endif
            
            let requestHandler = VNImageRequestHandler(data: data)
            do {
                try requestHandler.perform([request])
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
}

private extension CGImagePropertyOrientation {
    init(_ uiImageOrientation: UIImage.Orientation) {
        switch uiImageOrientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        default: self = .up
        }
    }
}
