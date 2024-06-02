//
//  AccountDeleteActionView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 08.05.2024.
//

import UIKit

final class AccountDeleteActionView: UIView {
    
    lazy var deleteButton = makeDeleteButton()
    lazy var cancelButton = makeCancelButton()
    
    private lazy var titleView = makeTitleView()
    private lazy var subtitleView = makeSubtitleView()
    
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
private extension AccountDeleteActionView {
    func initialize() {
        backgroundColor = Appearance.black
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 16.scale
    }
}

// MARK: Make constraints
private extension AccountDeleteActionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 24.scale),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8.scale),
            subtitleView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            subtitleView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 32.scale),
            deleteButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 8.scale),
            cancelButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AccountDeleteActionView {
    func makeTitleView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 18.scale))
            .lineHeight(25.2.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Delete.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Delete.Subtitle".localized.attributed(with: attrs)
        view.alpha = 0.8
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDeleteButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.black)
            .textAlignment(.center)
        let attrsTitle = "Delete.Delete".localized.attributed(with: attrs)
        
        let view = UIButton()
        view.setAttributedTitle(attrsTitle, for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCancelButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        let attrsTitle = "Delete.Cancel".localized.attributed(with: attrs)
        
        let view = UIButton()
        view.setAttributedTitle(attrsTitle, for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.black2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
