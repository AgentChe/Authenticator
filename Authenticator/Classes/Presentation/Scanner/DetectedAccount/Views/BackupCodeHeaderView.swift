//
//  BackupCodeHeaderView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import UIKit

class BackupCodeHeaderView: UICollectionReusableView {
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension BackupCodeHeaderView {
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
private extension BackupCodeHeaderView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Scan.AddTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.4
        addSubview(view)
        return view
    }
}
