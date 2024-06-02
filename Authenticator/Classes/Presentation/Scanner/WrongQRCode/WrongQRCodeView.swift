//
//  WrongQRCodeView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 29.04.2024.
//

import UIKit

final class WrongQRCodeView: UIView {

    lazy var grabberView = makeGrabberView()
    lazy var iconView = makeImageView()
    lazy var titleView = makeTitleView()
    lazy var subtitleView = makeSubtitleView()
    lazy var primaryButton = makePrimaryButton()
    
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
private extension WrongQRCodeView {
    func initialize() {
        layer.cornerRadius = 16.scale
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = Appearance.black
    }
}

// MARK: Make constraints
private extension WrongQRCodeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            grabberView.heightAnchor.constraint(equalToConstant: 4.scale),
            grabberView.widthAnchor.constraint(equalToConstant: 32.scale),
            grabberView.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            grabberView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 60.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.topAnchor.constraint(equalTo: grabberView.bottomAnchor, constant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 18.scale),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8.scale),
            subtitleView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            subtitleView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            primaryButton.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 43.scale),
            primaryButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            primaryButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale),
            primaryButton.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WrongQRCodeView {
    func makeGrabberView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 2.scale
        view.alpha = 0.2
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Scan.WrongQR")
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 18.scale))
            .lineHeight(25.2.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Scan.WrongQRTitle".localized.attributed(with: attrs)
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
        view.attributedText = "Scan.WrongQRSubtitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePrimaryButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.black)
            .textAlignment(.center)
        
        let attrsTitle = "Scan.WrongQRAction".localized.attributed(with: attrs)
        let view = UIButton()
        view.setAttributedTitle(attrsTitle, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.primary
        addSubview(view)
        return view
    }
}
