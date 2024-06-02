//
//  PasswordAlertView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 12.05.2024.
//
import UIKit

final class PasswordAlertView: UIView {
    private lazy var iconView = makeIconView()
    private lazy var labelView = makeLabelView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Appearance.red
        layer.cornerRadius = 16.scale
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension PasswordAlertView {
    func makeConstraints() { 
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: labelView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            labelView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale),
            labelView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12.scale),
            labelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PasswordAlertView {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Info")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabelView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Password.Message".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
