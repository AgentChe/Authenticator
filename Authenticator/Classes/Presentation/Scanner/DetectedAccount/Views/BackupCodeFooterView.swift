//
//  BackupCodeFooterView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import UIKit

class BackupCodeFooterView: UICollectionReusableView {
    lazy var addButton = makeButton()
    
    private var didTapAdd: (() -> Void)?
    
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
extension BackupCodeFooterView {
    func setup(didTapAdd: @escaping () -> Void) {
        self.didTapAdd = didTapAdd
    }
}

// MARK: Make constraints
private extension BackupCodeFooterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension BackupCodeFooterView {
    func makeButton() -> UIButton {
        var conf = UIButton.Configuration.plain()
        conf.imagePlacement = .trailing
        conf.imagePadding = 10.scale
        conf.image = UIImage(named: "Scan.Add")
        conf.contentInsets = .init(top: 8.scale, leading: 12.scale, bottom: 8.scale, trailing: 12.scale)
        conf.baseForegroundColor = .white.withAlphaComponent(0.2)
        
        
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4)
            .textColor(Appearance.white.withAlphaComponent(0.4))
            .textAlignment(.left)
        
        let attrsTitle = "Scan.Add".localized.attributed(with: attrs)
        
        let view = UIButton(configuration: conf)
        view.setAttributedTitle(attrsTitle, for: .normal)
        view.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        view.backgroundColor = .white.withAlphaComponent(0.08)
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension BackupCodeFooterView {
    @objc func addAction() {
        didTapAdd?()
    }
}
