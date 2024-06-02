//
//  HelperManager.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 15.05.2024.
//

import RxSwift
import RxCocoa

final class HelperManager {
    private let localAuthentication = LocalAuthenticationManager()
    
    func closeLearnMore() {
        UserDefaults.standard.setValue(false, forKey: Constants.learnMoreKey)
        changeLearnMoreRelay.accept(())
    }
    
    func closePasswordSetup() {
        UserDefaults.standard.setValue(false, forKey: Constants.passwordKey)
        changePasswordSetupRelay.accept(())
    }
    
    func showLearnMore() -> Observable<Bool> {
        return changeLearnMoreRelay
            .asObservable()
            .startWith(())
            .map { _ in
                let value = UserDefaults.standard.value(forKey: Constants.learnMoreKey) as? Bool
                return value ?? true
            }
    }
    
    func showPasswordSetup() -> Observable<Bool> {
        let trigger = Observable
            .merge(
                changePasswordSetupRelay.asObservable(),
                LocalAuthenticationMediator.shared.passwordAuthChange.asObservable().map { _ in () }
            )
            .startWith(())
        
        return trigger
            .map { [localAuthentication] _ in
                guard !localAuthentication.isAvailablePasswordAuthentication else { return false }
                
                let value = UserDefaults.standard.value(forKey: Constants.passwordKey) as? Bool
                return value ?? true
            }
    }
    
    private let changeLearnMoreRelay = PublishRelay<Void>()
    private let changePasswordSetupRelay = PublishRelay<Void>()
}

private extension HelperManager {
    enum Constants {
        static let learnMoreKey = "kHelperManagerLearnMoreKey"
        static let passwordKey = "kHelperManagerPasswordKey"
    }
}
