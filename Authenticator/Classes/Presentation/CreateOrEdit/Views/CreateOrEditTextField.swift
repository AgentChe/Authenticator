//
//  CreateOrEditTextField.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 04.05.2024.
//

import UIKit

class CreateOrEditTextField: UIView {
    private lazy var titleView = makeTitleView()
    lazy var textFieldView = makeTextField()
    private lazy var stackView = makeStackView()
    
    var editAction: (() -> Void)?
    var didChange: ((String) -> Void)?
    var isNeedFormatting: Bool = false
    
    var text: String = "" {
        didSet {
            textFieldView.text = text
            isEditing = !text.isEmpty
        }
    }
    
    var placeholder: String = "" {
        didSet {
            titleView.attributedText = placeholder.attributed(with: currentAttrs)
        }
    }
    
     private var isEditing: Bool = false {
        didSet {
            guard oldValue != isEditing else { return }
            textFieldView.isHidden = !isEditing
            titleView.attributedText = placeholder.attributed(with: currentAttrs)
        }
    }
    
    private var currentAttrs: TextAttributes {
        isEditing ? .focusedAttrs : .defaultAttrs
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(textFieldView)
        backgroundColor = .black.withAlphaComponent(0.3)
        layer.cornerRadius = 16.scale
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateOrEditTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditing = true
        editAction?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEditing = !(textField.text?.isEmpty  ?? true)
        editAction?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isNeedFormatting ? CreateOrEditFieldFormatter.textField(textField, shouldChangeCharactersIn: range, replacementString: string) : true
    }
}

// MARK: Make constraints
private extension CreateOrEditTextField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateOrEditTextField {
    func makeTitleView() -> UILabel {
        let view = UILabel()
        view.alpha = 0.4
        view.textColor = .white
        view.isUserInteractionEnabled = false
        return view
    }
    
    func makeTextField() -> UITextField {
        let view = UITextField()
        view.textColor = Appearance.white
        view.tintColor = Appearance.secondary
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        view.addTarget(self, action: #selector(changeText), for: .editingChanged)
        view.delegate = self
        view.isHidden = true
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

extension CreateOrEditTextField {
    @objc func changeText() {
        let text = textFieldView.text ?? ""
        didChange?(text)
    }
}

private extension TextAttributes {
    static let focusedAttrs = TextAttributes()
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(19.6.scale)
        .textColor(Appearance.white)
        .textAlignment(.left)
    
    static let defaultAttrs = TextAttributes()
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(22.4.scale)
        .textColor(Appearance.white)
        .textAlignment(.left)
}
