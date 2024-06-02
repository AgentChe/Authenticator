//
//  SearchAccountViewModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 19.05.2024.
//

import RxSwift
import RxCocoa

final class SearchAccountViewModel {
    private let initialModels: [TOTPModel]
    
    init(models: [TOTPModel]) {
        initialModels = models
    }
    
    enum Route {
        case action(TokenModel)
        case delete(TokenModel)
        case edit(TokenModel)
    }
    
    struct Input {
        let searchText: Observable<String>
        let didTapAccountMore: Signal<TOTPModel>
        let selectedAction: Signal<(AccountAction, TokenModel)>
        let deleteSignal: Signal<TokenModel>
    }
    
    struct Output {
        let elements: Driver<[TOTPModel]>
        let route: Signal<Route>
    }
    
    private let totpService = TOTPService()
    private let accountsManager = AccountsManager()
    private let disposeBag = DisposeBag()
    
    func configure(input: Input) -> Output {
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
        
        let tokenModels = AccountsMediator.share
            .accountsChange
            .asObservable()
            .flatMapLatest { [accountsManager] in
                accountsManager
                    .makeAccounts()
                    .catchAndReturn([])
            }
            .share(replay: 1)
        
        let modelsWithCode = tokenModels
            .map { [totpService] models in
                return totpService.makeTokens(for: models)
            }
            .startWith(initialModels)
        
        let items = Observable
            .combineLatest(modelsWithCode, input.searchText)
            .map { models, text in
                guard !text.isEmpty else { return models }
                return models.filter {
                    $0.model.issuer.contains(text) || $0.model.userName.contains(text)
                }
            }
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
        
        let route = Signal.merge(
            actionRoute,
            input.didTapAccountMore.map { .action($0.model) }
        )
        
        return Output(
            elements: items,
            route: route
        )
    }
}
