//
//  CreateOrEditFooterFieldView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 04.05.2024.
//

import UIKit

class CreateOrEditFooterFieldView: UICollectionReusableView {
    private lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CreateOrEditFooterFieldView {
    func setup(example: String) {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        label.attributedText = example.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension CreateOrEditFooterFieldView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateOrEditFooterFieldView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.6
        addSubview(view)
        return view
    }
}
