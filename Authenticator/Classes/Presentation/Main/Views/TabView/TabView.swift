//
//  TabView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 25.04.2024.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case accounts
        case scan
        case menu
    }
    
    lazy var accountsItem = makeItem(name: "Main.Accounts".localized, icon: UIImage(named: "Main.Accounts"))
    lazy var scanItem = makeItem(name: "Main.Scan".localized, icon: UIImage(named: "Main.Scan"))
    lazy var menuItem = makeItem(name: "Main.Menu".localized, icon: UIImage(named: "Main.Menu"))
    
    var selectedTab = Tab.accounts {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabView {
    func update() {
        [
            accountsItem,
            scanItem,
            menuItem
        ]
        .forEach {
            $0.mode = .deselected
        }
        
        switch selectedTab {
        case .accounts:
            accountsItem.mode = .selected
        case .scan:
            scanItem.mode = .selected
        case .menu:
            menuItem.mode = .selected
        }
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            accountsItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            accountsItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            accountsItem.topAnchor.constraint(equalTo: topAnchor),
            accountsItem.widthAnchor.constraint(equalTo: scanItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scanItem.leadingAnchor.constraint(equalTo: accountsItem.trailingAnchor),
            scanItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            scanItem.topAnchor.constraint(equalTo: topAnchor),
            scanItem.widthAnchor.constraint(equalTo: accountsItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            menuItem.leadingAnchor.constraint(equalTo: scanItem.trailingAnchor),
            menuItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            menuItem.topAnchor.constraint(equalTo: topAnchor),
            menuItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuItem.widthAnchor.constraint(equalTo: accountsItem.widthAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeItem(name: String, icon: UIImage?) -> TabItemView {
        let view = TabItemView(name: name, icon: icon)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
