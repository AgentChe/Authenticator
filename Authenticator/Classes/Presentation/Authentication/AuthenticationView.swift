//
//  AuthenticationView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 15.05.2024.
//
import UIKit

final class AuthenticationView: UIView {
    
    lazy var passwordField = makePasswordField()
    lazy var fieldButton = makeFieldButton()
    private lazy var imageView = makeImage()
    private lazy var backgroundView = makeBackgroundView()
    private lazy var fieldContainer = makeFieldContainer()
    private lazy var errorMessageLabel = makeErrorLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AuthenticationView {
    func setup(for biometry: BiometryType?) {
        switch biometry {
        case .faceID:
            fieldButton.setImage(UIImage(named: "FaceID"), for: .normal)
        case .touchID:
            fieldButton.setImage(UIImage(named: "TouchID"), for: .normal)
        case .none:
            fieldButton.isHidden = true
        }
    }
    
    func errorState(isShow: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.errorMessageLabel.alpha = isShow ? 1 : 0
            self.fieldContainer.layer.borderWidth = 1.scale
            self.fieldContainer.layer.borderColor = isShow ? Appearance.red.cgColor : UIColor.clear.cgColor
        }
    }
}

// MARK: Make constraints
private extension AuthenticationView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 98.scale),
            imageView.heightAnchor.constraint(equalToConstant: 120.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 164.scale : 120.scale)
        ])
        
        NSLayoutConstraint.activate([
            fieldContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40.scale),
            fieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            fieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            passwordField.topAnchor.constraint(equalTo: fieldContainer.topAnchor, constant: 17.scale),
            passwordField.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: -17.scale),
            passwordField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            fieldButton.heightAnchor.constraint(equalToConstant: 24.scale),
            fieldButton.widthAnchor.constraint(equalTo: fieldButton.heightAnchor),
            fieldButton.leadingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: 8.scale),
            fieldButton.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor, constant: -16.scale),
            fieldButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: 8.scale),
            errorMessageLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AuthenticationView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Background")
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePasswordField() -> UITextField {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white.withAlphaComponent(0.4))
        
        let view = UITextField()
        view.layer.cornerRadius = 16.scale
        view.tintColor = Appearance.secondary
        view.textColor = .white
        view.returnKeyType = .go
        view.isSecureTextEntry = true
        view.attributedPlaceholder = "Authentication.Placeholder".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        fieldContainer.addSubview(view)
        return view
    }
    
    func makeFieldContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFieldButton() -> UIButton {
        let view = UIButton()
        view.tintColor = Appearance.secondary
        view.translatesAutoresizingMaskIntoConstraints = false
        fieldContainer.addSubview(view)
        return view
    }
    
    func makeErrorLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .textColor(Appearance.red)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Authentication.Error".localized.attributed(with: attrs)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImage() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Splash.Image")
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
