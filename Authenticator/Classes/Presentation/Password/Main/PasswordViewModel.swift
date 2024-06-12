//
//  PasswordViewModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 10.05.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel {
    enum Route {
        case skip
        case finish
        case biometric(BiometryType)
    }
    
    struct Input {
        let didTapSkip: Signal<Void>
        let passwordValue: Observable<String?>
        let didTapNext: Signal<Void>
        let didTapBiometry: Signal<Void>
    }
    
    struct Output {
        let screenState: Driver<ScreenState>
        let biometryType: Driver<BiometryType?>
        let route: Signal<Route>
        let isShowError: Signal<Bool>
        let clearField: Signal<Void>
    }
    
    enum ScreenState {
        case set
        case change
        case confirm
    }
    
    private let localAuthentication = LocalAuthenticationManager()
}

extension PasswordViewModel {
    func configure(input: Input) -> Output {
        let initState: ScreenState = localAuthentication.isAvailablePasswordAuthentication ? .change : .set
        let currentScreenStateRelay = BehaviorRelay(value: initState)
        let currentBiomerty = Driver.just(initState == .set ? localAuthentication.availableBiometryType() : nil)
        
        let password = input.didTapNext
            .asObservable()
            .withLatestFrom(currentScreenStateRelay)
            .filter { $0 != .confirm }
            .withLatestFrom(input.passwordValue)
            .compactMap { $0 }
            .do(onNext: { _ in
                currentScreenStateRelay.accept(.confirm)
            })
            .share()
        
        let confirmPasssword = password
            .flatMapLatest { _ in
                input.didTapNext
                    .asObservable()
                    .withLatestFrom(currentScreenStateRelay)
                    .filter { $0 == .confirm }
                    .withLatestFrom(input.passwordValue)
                    .compactMap { $0 }
            }
        
        let isValidPassword = Observable
            .combineLatest(password, confirmPasssword)
            .compactMap { [weak self] password, confirmPasssword -> Bool? in
                guard let self else { return nil }
                
                let isValid = password == confirmPasssword
                
                if isValid {
                    switch initState {
                    case .set:
                        return localAuthentication.savePassword(password)
                    case .change:
                        return localAuthentication.updatePassword(password)
                    case .confirm:
                        return nil
                    }
                } else {
                    return isValid
                }
            }
            .share()
        
        let finishRoute = isValidPassword
            .compactMap { $0 ? Route.finish : nil }
            .asSignal(onErrorSignalWith: .empty())
        
        let biometryRoute = input.didTapBiometry
            .withLatestFrom(currentBiomerty)
            .compactMap { $0.map { Route.biometric($0) } }
        
        let route = Signal
            .merge(
                biometryRoute,
                finishRoute,
                input.didTapSkip.map { .skip }
            )
        
        let isShowError = isValidPassword
            .map(!)
            .asSignal(onErrorSignalWith: .empty())
        
        let clearField = currentScreenStateRelay
            .compactMap { $0 == .confirm ? () : nil }
            .asSignal(onErrorSignalWith: .empty())
        
        return Output(
            screenState: currentScreenStateRelay.asDriver(),
            biometryType: currentBiomerty,
            route: route, 
            isShowError: isShowError, 
            clearField: clearField
        )
    }
}
