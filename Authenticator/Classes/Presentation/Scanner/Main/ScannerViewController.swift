//
//  ScannerViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 25.04.2024.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa
import PhotosUI

class ScannerViewController: UIViewController {
    
    lazy var mainView = ScannerView()
    
    private let viewModel = ScannerViewModel()
    private lazy var session = createSession()
    private lazy var presentationDelegate = BottomSheetTransitionDelegate()
    
    private let disposeBag = DisposeBag()
    private let scannedValueRelay = PublishRelay<String>()
    private let didCloseDetectedScreen = PublishRelay<Void>()
    private let selectedMethodRelay = PublishRelay<ScannerViewModel.OtherMethod>()
    private let selectetPhotoRelay = PublishRelay<UIImage>()
    private let selectedFileRelay = PublishRelay<Data>()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if session?.isRunning != true {
            session?.startRunning()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if session?.isRunning == true {
            session?.stopRunning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.previewLayer = session.map { AVCaptureVideoPreviewLayer(session: $0)}
        
        let output = viewModel.configure(input: .init(
            scannedValue: scannedValueRelay.asSignal(),
            needRecognize: didCloseDetectedScreen.asSignal(),
            selectedMethod: selectedMethodRelay.asSignal(),
            didTapOtherMethod: mainView.otherMethodsButton.rx.tap.asSignal(), 
            selectedPhoto: selectetPhotoRelay.asSignal(), 
            selectedFile: selectedFileRelay.asSignal()
        ))
        
        output.route
            .emit(with: self) { $0.route(route: $1) }
            .disposed(by: disposeBag)
    }
}

private extension ScannerViewController {
    func route(route: ScannerViewModel.Route) {
        switch route {
        case let .detectedToken(token):
            showDetectedToken(token: token)
        case .wrongQR:
            showWrongQRCode()
        case .otherMethod:
            showOtherMethods()
        case .photoLibrary:
            showPhotoLibrary()
        case .files:
            showFilesPicker()
        case .manual:
            showManual()
        }
    }
    
    func showDetectedToken(token: TokenModel) {
        let vc = DetectedAccountViewController.make(token: token) { [weak self] in
            self?.didCloseDetectedScreen.accept(())
        }
        
        present(vc, animated: true)
    }
    
    func showWrongQRCode() {
        let vc = WrongQRCodeViewController.make { [weak self] in
            self?.didCloseDetectedScreen.accept(())
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = presentationDelegate
        present(vc, animated: true)
    }
    
    func showOtherMethods() {
        let vc = OtherMethodsViewController.make { [weak self] in
            self?.selectedMethodRelay.accept($0)
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = presentationDelegate
        present(vc, animated: true)
    }
    
    func showPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .screenshots, .panoramas])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func showFilesPicker() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image, .png, .tiff, .jpeg])
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }
    
    func showManual() {
        let vc = CreateOrEditViewController.make(tokenModel: nil)
        present(vc, animated: true)
    }
}

private extension ScannerViewController {
    func createSession() -> AVCaptureSession? {
        guard
            let videoDevice = AVCaptureDevice.default(for: .video),
            let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
        else {
            return nil
        }

        let captureSession = AVCaptureSession()
        let metadataOutput = AVCaptureMetadataOutput()

        guard
            captureSession.canAddInput(videoInput),
            captureSession.canAddOutput(metadataOutput)
        else {
            return nil
        }

        captureSession.addInput(videoInput)
        captureSession.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]

        return captureSession
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        let stringValue = metadataObjects
            .compactMap { ($0 as? AVMetadataMachineReadableCodeObject)?.stringValue }
            .first(where: { !$0.isEmpty })
        
        guard let stringValue = stringValue else { return }
        
        scannedValueRelay.accept(stringValue)
    }
}

extension ScannerViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        
        if itemProvider?.canLoadObject(ofClass: UIImage.self) == true {
            itemProvider?.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] image, _ in
                if let image = image as? UIImage {
                    self?.selectetPhotoRelay.accept(image)
                }
            })
        }
    }
}

extension ScannerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
        
        defer {
            DispatchQueue.main.async {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        guard let data = try? Data(contentsOf: url) else { return }
        
        controller.dismiss(animated: true) { [weak self] in
            self?.selectedFileRelay.accept(data)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}
