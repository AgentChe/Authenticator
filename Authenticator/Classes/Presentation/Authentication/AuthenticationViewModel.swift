//
//  AuthenticationViewModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 15.05.2024.
//

import RxSwift
import RxCocoa

final class AuthenticationViewModel {
    struct Input {
        let password: Observable<String>
        let editingEnd: Signal<Void>
        let didBeginEditing: Signal<Void>
        let didTapBiometry: Signal<Void>
    }
    
    struct Output {
        let biometryType: Driver<BiometryType?>
        let isShowError: Driver<Bool>
        let authorized: Signal<Void>
    }
    
    private let localAuthentication = LocalAuthenticationManager()
}

extension AuthenticationViewModel {
    func configure(input: Input) -> Output {
        
        let biometryType = Driver
            .just(localAuthentication.isAvailableBiometricAuthentication ? localAuthentication.availableBiometryType() : nil )
        
        let password = input.editingEnd
            .asObservable()
            .withLatestFrom(input.password)
        
        let authorizedResult = password
            .compactMap { [service = localAuthentication] password -> Bool in
                service.checkPassword(password)
            }
            .share()
        
        let biometryAuthorized = input.didTapBiometry
            .asObservable()
            .flatMapLatest { [service = localAuthentication] _ -> Observable<Bool> in
                service.biometricAuthenticationResult()
            }
        
        let isShowError = Observable
            .merge(
                authorizedResult.map(!),
                input.didBeginEditing.asObservable().map { _ in false }
            )
            .startWith(false)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
        
        let authorized = Observable
            .merge(
                authorizedResult,
                biometryAuthorized
            )
            .compactMap { $0 ? () : nil }
            .asSignal(onErrorSignalWith: .empty())
        
        return Output(
            biometryType: biometryType,
            isShowError: isShowError,
            authorized: authorized
        )
    }
}
