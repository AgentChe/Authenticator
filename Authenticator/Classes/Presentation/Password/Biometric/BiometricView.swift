//
//  BiometricView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 12.05.2024.
//
import UIKit

enum BiometryType {
    case faceID
    case touchID
}

final class BiometricView: UIView {
    
    lazy var actionButton = makeActionButton()
    lazy var skipButton = makeSkipButton()
    private lazy var titleLabel = makeTitleView()
    private lazy var subtitleLabel = makeSubtitleView()
    private lazy var iconView = makeIconView()
    private lazy var backgroundView = makeBackgroundView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Appearance.primary
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BiometricView {
    func setup(for type: BiometryType) {
        let titleAttrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 24.scale))
            .lineHeight(33.6.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let subtitleAttrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let actionAttrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.black)
            .textAlignment(.center)
        
        let titleText: String
        let subtitleText: String
        let actionText: String
        let icon: UIImage?
        
        switch type {
        case .faceID:
            icon = UIImage(named: "FaceID")
            titleText = "Biometric.FaceID.Title".localized
            subtitleText = "Biometric.FaceID.Subtitle".localized
            actionText = "Biometric.FaceID.Action".localized
        case .touchID:
            icon = UIImage(named: "TouchID")
            titleText = "Biometric.TouchID.Title".localized
            subtitleText = "Biometric.TouchID.Subtitle".localized
            actionText = "Biometric.TouchID.Action".localized
        }
        
        iconView.image = icon
        titleLabel.attributedText = titleText.attributed(with: titleAttrs)
        subtitleLabel.attributedText = subtitleText.attributed(with: subtitleAttrs)
        actionButton.setAttributedTitle(actionText.attributed(with: actionAttrs), for: .normal)
    }
}

// MARK: Make constraints
private extension BiometricView {
    func makeConstraints() { 
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 152.scale : 96.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 80.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            actionButton.heightAnchor.constraint(equalToConstant: 59.scale)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 8.scale),
            skipButton.leadingAnchor.constraint(equalTo: actionButton.leadingAnchor),
            skipButton.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor),
            skipButton.heightAnchor.constraint(equalTo: actionButton.heightAnchor),
            skipButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -40.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension BiometricView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Background")
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleView() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleView() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.tintColor = Appearance.secondary
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActionButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSkipButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        let attrsString = "Biometric.Skip".localized.attributed(with: attrs)
        let view = UIButton()
        view.setAttributedTitle(attrsString, for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.black2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
