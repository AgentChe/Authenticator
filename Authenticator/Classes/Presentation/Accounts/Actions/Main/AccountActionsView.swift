//
//  AccountActionsView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 08.05.2024.
//

import UIKit
import RxCocoa
import RxSwift

class AccountActionsView: UIView {
    
    lazy var titleView = makeTitleView()
    lazy var editAction = makeActionButton(for: .edit)
    lazy var deleteAction = makeActionButton(for: .delete)

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension AccountActionsView {
    func initialize() {
        backgroundColor = Appearance.black
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 16.scale
    }
}

// MARK: Make constraints
private extension AccountActionsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 24.scale),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            editAction.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24.scale),
            editAction.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            editAction.trailingAnchor.constraint(equalTo: titleView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteAction.topAnchor.constraint(equalTo: editAction.bottomAnchor, constant: 18.scale),
            deleteAction.leadingAnchor.constraint(equalTo: editAction.leadingAnchor),
            deleteAction.trailingAnchor.constraint(equalTo: editAction.trailingAnchor),
            deleteAction.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AccountActionsView {
    func makeTitleView() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActionButton(for action: AccountAction) -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        var conf = UIButton.Configuration.plain()
        conf.imagePadding = 12.scale
        
        let view = UIButton(configuration: conf)
        view.backgroundColor = .clear
        view.setAttributedTitle(action.name.attributed(with: attrs), for: .normal)
        view.setImage(action.icon, for: .normal)
        view.contentHorizontalAlignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
