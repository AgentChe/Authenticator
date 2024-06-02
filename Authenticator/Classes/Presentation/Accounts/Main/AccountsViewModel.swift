//
//  AccountsViewModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import RxSwift
import RxCocoa

final class AccountsViewModel {
    private lazy var totpService = TOTPService()
    
    enum Route {
        case action(TokenModel)
        case delete(TokenModel)
        case edit(TokenModel)
        case scan
        case search([TOTPModel])
        case setupPassword
        case error(Error)
    }
    
    struct Input {
        let didTapCloseSetupPassword: Signal<Void>
        let didTapLearnMore: Signal<Void>
        let didTapCloseLearnMore: Signal<Void>
        let didTapAccountMore: Signal<TOTPModel>
        let didTapAdd: Signal<Void>
        let selectedAction: Signal<(AccountAction, TokenModel)>
        let deleteSignal: Signal<TokenModel>
        let didSelectItem: Signal<AccountCellType>
    }
    
    struct Output {
        let elements: Driver<[AccountCellType]>
        let isShowLearnMore: Driver<Bool>
        let route: Signal<Route>
        let isLoading: Driver<Bool>
    }
    
    private let helperManager = HelperManager()
    private let accountsManager = AccountsManager()
    private let disposeBag = DisposeBag()
}

extension AccountsViewModel {
    
    func configure(input: Input) -> Output {
        let activityIndicator = RxActivityIndicator()
        
        input.didTapCloseLearnMore
            .emit(with: self) { base, _ in base.helperManager.closeLearnMore() }
            .disposed(by: disposeBag)
        
        input.didTapCloseSetupPassword
            .emit(with: self) { base, _ in base.helperManager.closePasswordSetup() }
            .disposed(by: disposeBag)
        
        input.deleteSignal
            .asObservable()
            .withUnretained(accountsManager)
            .flatMapLatest { manager, token -> Observable<Void> in
                manager
                    .delete(token: token)
                    .andThen(.just(()))
                    .catchAndReturn(())
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        let tokenModelsRequest = AccountsMediator.share
            .accountsChange
            .asObservable()
            .startWith(())
            .flatMapLatest { [accountsManager] in
                accountsManager
                    .makeAccounts()
                    .materialize()
                    .trackActivity(activityIndicator)
            }
            .share(replay: 1)
        
        let tokenModels = tokenModelsRequest
            .compactMap { $0.element }
            .share()
        
        let modelsWithCode = tokenModels
            .map { [totpService] models in
                return totpService.makeTokens(for: models)
            }
            .share(replay: 1)
        
        let isShowSetupPassword = helperManager
            .showPasswordSetup()
        
        let accountsCells = modelsWithCode
            .map { elements -> [AccountCellType] in
                elements.map { .account($0) }
            }
        
        let elements = Observable
            .combineLatest(isShowSetupPassword, accountsCells) { isShowSetupPassword, accounts in
                var elements: [AccountCellType] = []
                if isShowSetupPassword {
                    elements.append(.setupPassword)
                }
                
                elements.append(.title("Accounts"))
                
                if accounts.isEmpty {
                    elements.append(.empty)
                } else {
                    elements.append(.search)
                    elements.append(contentsOf: accounts)
                }
                
                return elements
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let isShowLearnMore = helperManager
            .showLearnMore()
            .asDriver(onErrorDriveWith: .empty())
        
        let actionRoute = input.selectedAction
            .map { action, token -> Route in
                switch action {
                case .edit:
                    return .edit(token)
                case .delete:
                    return .delete(token)
                }
            }
        
        let itemRoute = input.didSelectItem
            .asObservable()
            .withLatestFrom(modelsWithCode) { ($0, $1) }
            .compactMap { model, tokens -> Route? in
                switch model {
                case .search:
                    return .search(tokens)
                case .setupPassword:
                    return .setupPassword
                default:
                    return nil
                }
            }
            .asSignal(onErrorSignalWith: .empty())
        
        let errorRoute = tokenModelsRequest
            .compactMap { $0.error.map { Route.error($0) } }
            .asSignal(onErrorSignalWith: .empty())
        
        let route = Signal.merge(
            input.didTapAccountMore.map { .action($0.model) },
            input.didTapAdd.map { .scan },
            actionRoute,
            itemRoute,
            errorRoute
        )
        
        return Output(
            elements: elements,
            isShowLearnMore: isShowLearnMore,
            route: route, 
            isLoading: activityIndicator.asDriver()
        )
    }
}
