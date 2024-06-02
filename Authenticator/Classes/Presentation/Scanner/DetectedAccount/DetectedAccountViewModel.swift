//
//  DetectedAccountViewModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import RxSwift
import RxCocoa

final class DetectedAccountViewModel {
    private let _token: TokenModel
    private let totpService = TOTPService()
    private let accountsManager = AccountsManager()
    
    init(token: TokenModel) {
        self._token = token
    }
    
    enum Route {
        case addCode
        case close
        case paygate
    }
    
    struct Input {
        let didTapSave: Signal<Void>
        let didTapAddCodes: Signal<Void>
        let didTapClose: Signal<Void>
        let addBackupCode: Signal<String>
        let deleteCode: Signal<String>
    }
    
    struct Output {
        let route: Signal<Route>
        let elements: Driver<[DetectedAccountSection]>
    }
}

extension DetectedAccountViewModel {
    func confiure(input: Input) -> Output {
        enum Action {
            case add(String)
            case delete(String)
        }
        
        let savedToken = accountsManager
            .makeAccounts()
            .catchAndReturn([])
            .map { [detected = _token] accounts in
                accounts.first(where: { $0.secret == detected.secret })
            }
            .share(replay: 1)
        
        let currentToken = savedToken
            .flatMapLatest { [detected = _token] token in
                let currentToken = token ?? detected
                return Observable<Action>
                    .merge(
                        input.addBackupCode.asObservable().map { .add($0) },
                        input.deleteCode.asObservable().map { .delete($0) }
                    )
                    .scan(into: currentToken) { token, action in
                        switch action {
                        case let .add(code):
                            if !token.backupCodes.contains(code) {
                                token.backupCodes.append(code)
                            }
                        case let .delete(code):
                            token.backupCodes.removeAll(where: { $0 == code })
                        }
                    }
                    .startWith(currentToken)
            }
            .share(replay: 1)
        
        let codeSection = savedToken
            .compactMap { [weak self] token -> DetectedAccountSection? in
                guard let self else { return nil }
                let currentToken = token ?? _token
                let model = totpService.makeToken(for: currentToken)
                
                return DetectedAccountSection(type: .code, items: [.code(model)])
            }
        
        let accountsInfoSection = savedToken
            .map { [detected = _token] saved -> DetectedAccountSection in
                let item = DetectedAccountSection.SectionItem.accountInfo(model: saved ?? detected, isSaved: saved != nil)
                return .init(type: .accountInfo, items: [item])
            }
        
        let backupCodesSection = currentToken
            .map { currentModel in
                DetectedAccountSection(type: .backupCodes, items: currentModel.backupCodes.map { .backupCode($0) })
            }
        
        let elements = Observable
            .combineLatest([accountsInfoSection, codeSection, backupCodesSection])
            .asDriver(onErrorDriveWith: .empty())
        
        let saveRoute = input.didTapSave
            .asObservable()
            .withLatestFrom(currentToken)
            .flatMapLatest { token -> Observable<Route> in
                AccountsManager()
                    .save(token: token)
                    .andThen(.just(true))
                    .catchAndReturn(false)
                    .compactMap { $0 ? .close : nil }
            }
            .asSignal(onErrorSignalWith: .empty())
            
        let addCodeRoute = input.didTapAddCodes
            .asObservable()
            .withLatestFrom(currentToken)
            .map { token in
                guard !SessionManager().hasActiveSubscriptions() else { return Route.addCode }
                return token.backupCodes.count < 1 ? .addCode : .paygate
            }
            .asSignal(onErrorSignalWith: .empty())
        
        let route = Signal<Route>
            .merge(
                input.didTapClose.map { .close },
                addCodeRoute,
                saveRoute
            )
        
        return Output(
            route: route,
            elements: elements
        )
    }
}
