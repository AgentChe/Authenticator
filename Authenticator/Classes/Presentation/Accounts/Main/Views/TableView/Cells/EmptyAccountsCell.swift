//
//  EmptyAccountsCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit

final class EmptyAccountsCell: UITableViewCell {
    
    lazy var titleView = makeTitleView()
    lazy var subtitleView = makeSubtitleView()
    lazy var button = makeButton()
    private lazy var containerView = makeContainer()
    
    private var didTapAdd: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension EmptyAccountsCell {
    func setup(didTapAdd: @escaping () -> Void) {
        self.didTapAdd = didTapAdd
    }
}

// MARK: Private
private extension EmptyAccountsCell {
    func initialize() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension EmptyAccountsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24.scale),
            titleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            titleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16.scale),
            subtitleView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            subtitleView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40.scale),
            button.widthAnchor.constraint(equalTo: button.heightAnchor),
            button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            button.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 24.scale),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension EmptyAccountsCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 10.scale
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Accounts.EmptyTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeSubtitleView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.alpha = 0.6
        view.attributedText = "Accounts.EmptySubtitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Accounts.Add"), for: .normal)
        view.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}

private extension EmptyAccountsCell {
    @objc func addAction() {
        didTapAdd?()
    }
}
