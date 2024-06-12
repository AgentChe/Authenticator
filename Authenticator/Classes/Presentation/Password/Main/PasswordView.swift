//
//  PasswordView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 10.05.2024.
//

import UIKit

final class PasswordView: UIView {
    
    lazy var skipButton = makeSkipButton()
    lazy var titleView = makeTitleView()
    lazy var subtitleView = makeSubtitleView()
    lazy var passwordField = makePasswordField()
    lazy var nextButton = makeNextButton()
    lazy var fieldButton = makeFieldButton()
    private lazy var stackView = makeStackView()
    private lazy var backgroundView = makeBackgroundView()
    private lazy var fieldContainer = makeFieldContainer()
    private lazy var alertView = makeAlertView()
    private lazy var errorMessageLabel = makeErrorLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Appearance.primary
        makeConstraints()
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(subtitleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PasswordView {
    func setup(for state: PasswordViewModel.ScreenState) {
        passwordField.text = nil
        switch state {
        case .set:
            titleView.attributedText = "Password.SetTitle".localized.attributed(with: .titleAttrs)
        case .change:
            titleView.attributedText = "Password.ChangeTitle".localized.attributed(with: .titleAttrs)
        case .confirm:
            titleView.attributedText = "Password.ConfirmTitle".localized.attributed(with: .titleAttrs)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.alertView.alpha = state == .confirm ? 1 : 0
            self.subtitleView.isHidden = state == .confirm
        }
    }
    
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
private extension PasswordView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.heightAnchor.constraint(equalToConstant: 40.scale),
            skipButton.widthAnchor.constraint(equalToConstant: 65.scale),
            skipButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 80.scale : 36.scale),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 32.scale),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            fieldContainer.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24.scale),
            fieldContainer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            fieldContainer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
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
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 60.scale),
            nextButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            alertView.leadingAnchor.constraint(equalTo: nextButton.leadingAnchor),
            alertView.trailingAnchor.constraint(equalTo: nextButton.trailingAnchor),
            alertView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PasswordView {
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
        return view
    }
    
    func makeSubtitleView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Password.Subtitle".localized.attributed(with: attrs)
        view.alpha = 0.8
        return view
    }
    
    func makeNextButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let arttsString = "Password.Next".localized.attributed(with: attrs)
        
        let view = UIButton()
        view.setAttributedTitle(arttsString, for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSkipButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let arttsString = "Password.Skip".localized.attributed(with: attrs)
        
        let view = UIButton()
        view.setAttributedTitle(arttsString, for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
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
        view.attributedPlaceholder = "Password.Placeholder".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        fieldContainer.addSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
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
    
    func makeAlertView() -> PasswordAlertView {
        let view = PasswordAlertView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeErrorLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .textColor(Appearance.red)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Password.ConfirmError".localized.attributed(with: attrs)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let titleAttrs = TextAttributes()
        .font(Fonts.Inter.semiBold(size: 24.scale))
        .lineHeight(33.6.scale)
        .textColor(Appearance.white)
        .textAlignment(.left)
}

#if DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct PasswordView_Previews: PreviewProvider {
    
    struct PasswordViewRepresentable: UIViewRepresentable {
        func makeUIView(context: Context) -> PasswordView {
            let view = PasswordView()
            view.setup(for: .change)
            return view
        }
        func updateUIView(_ uiView: PasswordView, context: Context) {
            
        }
    }

    static var previews: some View {
        return PasswordViewRepresentable()
    }
}
#endif
