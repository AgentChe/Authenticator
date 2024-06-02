//
//  LocalAuthenticationMediator.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 13.05.2024.
//

import RxSwift
import RxCocoa

final class LocalAuthenticationMediator {
    static let shared = LocalAuthenticationMediator()
    
    private lazy var changeBiometricAuthState = PublishRelay<Void>()
    private lazy var schangePasswordAuth = PublishRelay<Bool>()
    
    private init() {}
}

// MARK: Public
extension LocalAuthenticationMediator {
    func notify() {
        DispatchQueue.main.async { [weak self] in
            self?.changeBiometricAuthState.accept(())
        }
    }
    
    func notify(password isEnabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.schangePasswordAuth.accept(isEnabled)
        }
    }
}

// MARK: Public (Rx)
extension LocalAuthenticationMediator {
    var biometricAuthChange: Signal<Void> {
        return changeBiometricAuthState.asSignal()
    }
    
    var passwordAuthChange: Signal<Bool> {
        return schangePasswordAuth.asSignal()
    }
}
