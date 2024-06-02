//
//  AccountsView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit

enum StateTable {
    case `default`
    case search
}

final class AccountsView: UIView {
    
    lazy var learnMoreView = makeLearnView()
    lazy var tableView = makeTableView()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableTopConstraint: NSLayoutConstraint?
    
    func updateConstraint(isShow: Bool) {
        if !isShow {
            tableTopConstraint = tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12.scale)
            tableTopConstraint?.isActive = true
            UIView.animate(withDuration: 0.2) {
                self.learnMoreView.isHidden = true
                self.layoutIfNeeded()
            }
        }
    }
    
    func setup(isLoading: Bool) {
        if isLoading {
            preloader.startAnimating()
        } else {
            preloader.stopAnimating()
        }
        preloader.isHidden = !isLoading
        tableView.isHidden = isLoading
    }
}

// MARK: Make constraints
private extension AccountsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            learnMoreView.topAnchor.constraint(equalTo: topAnchor),
            learnMoreView.leadingAnchor.constraint(equalTo: leadingAnchor),
            learnMoreView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let tableTopConstraint = tableView.topAnchor.constraint(equalTo: learnMoreView.bottomAnchor, constant: 12.scale)
        self.tableTopConstraint = tableTopConstraint
        
        NSLayoutConstraint.activate([
            tableTopConstraint,
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AccountsView {
    func makeLearnView() -> LearnMoreHeaderView {
        let view = LearnMoreHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> AccountsTableView {
        let view = AccountsTableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 32.scale, height: 32.scale))
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
