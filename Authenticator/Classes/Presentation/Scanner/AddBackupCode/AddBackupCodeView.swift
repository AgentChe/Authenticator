//
//  AddBackupCodeView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 30.04.2024.
//

import UIKit

class AddBackupCodeView: UIView {
    lazy var container = makeTextContainer()
    lazy var textField = makeTextField()
    lazy var saveButton = makeSaveButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Appearance.black
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension AddBackupCodeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.scale),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale),
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60.scale),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AddBackupCodeView {
    func makeTextField() -> UITextField {
        let view = UITextField()
        view.tintColor = Appearance.secondary
        view.textColor = Appearance.white
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.black)
            .textAlignment(.center)
        let attrsTitle = "Save".localized.attributed(with: attrs)
        
        let view = UIButton()
        view.setAttributedTitle(attrsTitle, for: .disabled)
        view.setAttributedTitle(attrsTitle, for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
