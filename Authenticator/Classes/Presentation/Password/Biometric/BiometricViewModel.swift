//
//  BiometricViewModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 12.05.2024.
//

import RxSwift
import RxCocoa

final class BiometricViewModel {
    enum Route {
        case dismiss
    }
    
    struct Input {
        let didTapAction: Signal<Void>
        let didTapSkip: Signal<Void>
        let didTapClose: Signal<Void>
    }
    
    struct Output {
        let route: Signal<Route>
    }
    
    private let localAuthentication = LocalAuthenticationManager()
}


extension BiometricViewModel {
    func configure(input: Input) -> Output {
        let biometricRoute = input.didTapAction
            .asObservable()
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self else { return .empty() }
                return localAuthentication.setBiometricAuthentication(isEnabled: true)
            }
            .compactMap { $0 ? Route.dismiss : nil }
        
        let route = Signal
            .merge(
                biometricRoute.asSignal(onErrorSignalWith: .empty()),
                input.didTapSkip.map { .dismiss },
                input.didTapClose.map { .dismiss }
            )
        
        return Output(
            route: route
        )
    }
}
