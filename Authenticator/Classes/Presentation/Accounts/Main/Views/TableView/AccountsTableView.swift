//
//  AccountsTableView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit
import RxCocoa

final class AccountsTableView: UITableView {
    
    lazy var didTapMore = PublishRelay<TOTPModel>()
    lazy var didTapCloseSetupPassword = PublishRelay<Void>()
    lazy var didTapAdd = PublishRelay<Void>()
    lazy var didSelectItem = PublishRelay<AccountCellType>()

    var elements: [AccountCellType] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountsTableView {
    func setup(elements: [AccountCellType]) {
        self.elements = elements
        reloadData()
    }
}

extension AccountsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EmptyAccountsCell.self), for: indexPath) as! EmptyAccountsCell
            cell.setup { [weak self] in
                self?.didTapAdd.accept(())
            }
            return cell
        case .setupPassword:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SetupPasswordCell.self), for: indexPath) as! SetupPasswordCell
            cell.setup { [weak self] in
                self?.didTapCloseSetupPassword.accept(())
            }
            return cell
        case let .account(model):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountCell.self), for: indexPath) as! AccountCell
            cell.setup(model: model) { [weak self] in
                self?.didTapMore.accept(model)
            }
            return cell
        case let .title(title):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SectionTitleCell.self), for: indexPath) as! SectionTitleCell
            cell.setup(title: title)
            return cell
        case .search:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchCell.self), for: indexPath) as! SearchCell
            return cell
        }
        
    }
}

extension AccountsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = elements[indexPath.row]
        didSelectItem.accept(model)
    }
}

private extension AccountsTableView {
    func initialize() {
        dataSource = self
        delegate = self
        separatorStyle = .none
        register(AccountCell.self, forCellReuseIdentifier: String(describing: AccountCell.self))
        register(EmptyAccountsCell.self, forCellReuseIdentifier: String(describing: EmptyAccountsCell.self))
        register(SetupPasswordCell.self, forCellReuseIdentifier: String(describing: SetupPasswordCell.self))
        register(SectionTitleCell.self, forCellReuseIdentifier: String(describing: SectionTitleCell.self))
        register(SearchCell.self, forCellReuseIdentifier: String(describing: SearchCell.self))
    }
}

