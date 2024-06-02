//
//  SetupPasswordCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit

final class SetupPasswordCell: UITableViewCell {
    
    lazy var titleView = makeTitleView()
    lazy var subtitleView = makeSubtitleView()
    lazy var iconView = makeImageView()
    lazy var closeButton = makeCloseButton()
    private lazy var containerView = makeContainer()
    
    private var didTapClose: (() -> Void)?

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
extension SetupPasswordCell {
    func setup(didTapClose: @escaping () -> Void) {
        self.didTapClose = didTapClose
    }
}

// MARK: Private
private extension SetupPasswordCell {
    func initialize() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    @objc func didTapCloseButton() {
        didTapClose?()
    }
}

// MARK: Make constraints
private extension SetupPasswordCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 48.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.scale),
            titleView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12.scale),
            titleView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8.scale),
            subtitleView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            subtitleView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            subtitleView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 20.scale),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18.scale),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SetupPasswordCell {
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
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Accounts.PasswordTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeSubtitleView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Accounts.PasswordSubtitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Accounts.PasswordIcon")
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Accounts.PasswordClose"), for: .normal)
        view.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}
