//
//  CreateOrEditViewModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 04.05.2024.
//

import RxSwift
import RxCocoa

final class CreateOrEditViewModel {
    typealias Section = CreateOrEditSection
    typealias SectionItem = CreateOrEditSection.SectionItem
    
    private let _token: TokenModel?
    private let accountsManager = AccountsManager()
    
    init(token: TokenModel?) {
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
        let changeFields: Signal<[Section.FieldType: String]>
    }
    
    struct Output {
        let title: Driver<String>
        let elements: Driver<[Section]>
        let route: Signal<Route>
        let saveIsEnabled: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        
        enum Action {
            case add(String)
            case delete(String)
        }
        
        let currentAccountValue = input.changeFields
            .asObservable()
            .compactMap { $0[.account] }
            .startWith(_token?.issuer ?? "")
            .share(replay: 1)
        
        let currentNameValue = input.changeFields
            .asObservable()
            .compactMap { $0[.name] }
            .startWith(_token?.userName ?? "")
            .share(replay: 1)
        
        let currentSecretValue = input.changeFields
            .asObservable()
            .compactMap { $0[.serviceCode] }
            .startWith(_token?.secret.base32EncodedString ?? "")
            .map { $0.filter { !$0.isWhitespace } }
            .share(replay: 1)
        
        let currentBackupCodes = Observable<Action>
            .merge(
                input.addBackupCode.asObservable().map { .add($0) },
                input.deleteCode.asObservable().map { .delete($0) }
            )
            .scan(into: _token?.backupCodes ?? []) { elements, action in
                switch action {
                case let .add(code):
                    if !elements.contains(code) {
                        elements.append(code)
                    }
                case let .delete(code):
                    elements.removeAll(where: { $0 == code })
                }
            }
            .startWith( _token?.backupCodes ?? [])
            .share(replay: 1)
        
        let accountSection = currentAccountValue
            .take(1)
            .map { value in
                return Section(type: .field(example: "CreateOrEdit.AccountExample".localized), items: [.field(.account, value)])
            }
        
        let nameSection = currentNameValue
            .take(1)
            .map { value in
                return Section(type: .field(example: "CreateOrEdit.NameExample".localized), items: [.field(.name, value)])
            }
        
        let serviceCodeSection = currentSecretValue
            .take(1)
            .map { value in
                return Section(type: .field(example: nil), items: [.field(.serviceCode, value)])
            }
        
        let backupCodesSection = currentBackupCodes
            .map { Section(type: .backupCodes, items: $0.map { .backupCode(code: $0) }) }
            .share(replay: 1)
        
        let elements = Observable
            .combineLatest([accountSection, nameSection, serviceCodeSection, backupCodesSection])
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
        
        let data = Observable
            .combineLatest(currentAccountValue, currentNameValue, currentSecretValue, currentBackupCodes)
            .share(replay: 1)

        let saveRoute = input.didTapSave
            .asObservable()
            .withLatestFrom(data)
            .flatMapLatest { [accountsManager, initial = _token] data -> Observable<Route> in
                let newToken = TokenModel(
                    old: initial,
                    issuer: data.0,
                    userName: data.1,
                    secret: data.2,
                    backupCodes: data.3
                )
                
                guard let newToken, !TOTPGenerator.getCode(for: newToken, with: .init()).isEmpty else { return .empty() }
                
                return accountsManager
                    .save(token: newToken)
                    .andThen(.just(.close))
            }
            .asSignal(onErrorSignalWith: .empty())
        
        let saveIsEnabled = data
            .map { data in
                return !data.0.isEmpty && !data.1.isEmpty && !data.2.isEmpty
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let addCodeRoute = input.didTapAddCodes
            .asObservable()
            .withLatestFrom(currentBackupCodes)
            .map { codes in
                guard !SessionManager().hasActiveSubscriptions() else { return Route.addCode }
                return codes.count < 1 ? .addCode : .paygate
            }
            .asSignal(onErrorSignalWith: .empty())
        
        let route = Signal<Route>
            .merge(
                input.didTapClose.map { .close },
                addCodeRoute,
                saveRoute
            )
        
        let title = _token == nil
            ? "CreateOrEdit.CreateTilte".localized
            : "CreateOrEdit.EditTilte".localized
        
        return Output(
            title: .just(title),
            elements: elements,
            route: route, 
            saveIsEnabled: saveIsEnabled
        )
    }
}

private extension TokenModel {
    init?(old: TokenModel?, issuer: String, userName: String, secret: String, backupCodes: [String]) {
        guard let secretData = Data(base32Encoded: secret) else { return nil }
        self.secret = secretData
        self.id = old?.id ?? UUID().uuidString
        self.issuer = issuer
        self.userName = userName
        self.backupCodes = backupCodes
        self.algorithm = old?.algorithm ?? .sha256
        self.digits = old?.digits ?? 6
        self.period = old?.period ?? 30
    }
}
