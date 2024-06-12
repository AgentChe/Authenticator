//
//  AccountsMediator.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 25.05.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class AccountsMediator {
    static let share = AccountsMediator()
    
    private lazy var changeAccountsRelay = PublishRelay<Void>()
    
    private init() {}
}

// MARK: Public
extension AccountsMediator {
    func notify() {
        DispatchQueue.main.async { [weak self] in
            self?.changeAccountsRelay.accept(())
        }
    }
}

// MARK: Public (Rx)
extension AccountsMediator {
    var accountsChange: Signal<Void> {
        return changeAccountsRelay.asSignal()
    }
}
