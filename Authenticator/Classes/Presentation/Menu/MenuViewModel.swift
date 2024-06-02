//
//  MenuViewModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 15.05.2024.
//

import RxSwift
import RxCocoa

final class MenuViewModel {
    typealias Section = MenuSection
    typealias SectionItem = MenuSection.SectionItem
    
    enum Route {
        case password
        case learnMore
        case open(url: URL)
    }
    
    struct Input {
        let selectedElement: Signal<SectionItem>
        let didTapLearnMore: Signal<Void>
        let biometryIsOn: Signal<Bool>
    }
    
    struct Output {
        let elements: Driver<[Section]>
        let route: Signal<Route>
    }
    
    private let localAuthentication = LocalAuthenticationManager()
    private let disposeBag = DisposeBag()
}

extension MenuViewModel {
    func configure(input: Input) -> Output {
        let biometryIsOn = input.biometryIsOn
            .asObservable()
            .flatMapLatest { [localAuthentication] isOn in
                localAuthentication.setBiometricAuthentication(isEnabled: isOn)
            }
            .map { _ in () }
        
        let passwordCell = LocalAuthenticationMediator.shared.passwordAuthChange
            .asObservable()
            .startWith(localAuthentication.isAvailablePasswordAuthentication)
            .distinctUntilChanged()
            .map { SectionItem.actionWithIcon($0 ? .changePassword : .setupPassword) }
        
        let biometricCell = Observable
            .merge(
                biometryIsOn,
                LocalAuthenticationMediator.shared.biometricAuthChange.asObservable()
            )
            .startWith(())
            .startWith()
            .map { [localAuthentication] _ -> SectionItem? in
                localAuthentication.availableBiometryType()
                    .map { .biometry($0, localAuthentication.isAvailableBiometricAuthentication) }
            }
        
        let elements = Observable
            .combineLatest(passwordCell, biometricCell)
            .map { password, biometry -> [Section] in
                [
                    .init(section: .setup, items: [.setup]),
                    .init(section: .account, items: [password, biometry].compactMap { $0 }),
                    .init(section: .about, items: [.action(.privacyPolicy), .action(.termsOfUse), .action(.contactUs)])
                ]
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let cellRoute = input.selectedElement
            .compactMap { element -> Route? in
                switch element {
                case let .action(type):
                    return type.route
                case let .actionWithIcon(type):
                    return type.route
                default:
                    return nil
                }
            }
        
        let route = Signal
            .merge(
                cellRoute,
                input.didTapLearnMore.map { .learnMore }
            )
        
        return Output(
            elements: elements,
            route: route
        )
    }
}

private extension MenuSection.ActionType {
    var route: MenuViewModel.Route {
        switch self {
        case .termsOfUse:
            return .open(url: GlobalDefinitions.termsOfUseUrl)
        case .privacyPolicy:
            return .open(url: GlobalDefinitions.privacyPolicyUrl)
        case .contactUs:
            return .open(url: GlobalDefinitions.contactUsUrl)
        }
    }
}

private extension MenuSection.ActionWithIcon {
    var route: MenuViewModel.Route {
        switch self {
        case .setupPassword, .changePassword:
            return .password
        }
    }
}
