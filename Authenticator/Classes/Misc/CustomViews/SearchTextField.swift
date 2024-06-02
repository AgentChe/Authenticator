//
//  SearchTextField.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit

class SearchTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 16.scale, y: 16.scale, width: 24.scale, height: 24.scale)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.maxX - 16.scale - 24.scale, y: 16.scale, width: 24.scale, height: 24.scale)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return CGRect(
            x: rect.origin.x + 8.scale,
            y: rect.origin.y,
            width: rect.width - rightViewRect(forBounds: bounds).width - 8.scale,
            height: rect.height
        )
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return CGRect(
            x: rect.origin.x + 8.scale,
            y: rect.origin.y,
            width: rect.width - rightViewRect(forBounds: bounds).width - 8.scale,
            height: rect.height
        )
    }
    
    override var intrinsicContentSize: CGSize {
        let leftRect = leftViewRect(forBounds: bounds)
        return CGSize(width: super.intrinsicContentSize.width, height: leftRect.height + leftRect.origin.y * 2)
    }
}

private extension SearchTextField {
    func initialize() {
        leftView = UIImageView(image: UIImage(named: "Search"))
        leftViewMode = .always
        let clearButton = UIButton()
        clearButton.setImage(UIImage(named: "Clear"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        rightView = clearButton
        layer.cornerRadius = 16.scale
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        tintColor = Appearance.secondary
        textColor = .white
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white.withAlphaComponent(0.4))
        
        attributedPlaceholder = "Search".localized.attributed(with: attrs)
    }
}

private extension SearchTextField {
    @objc func clearText() {
        text = ""
        sendActions(for: .valueChanged)
    }
}
