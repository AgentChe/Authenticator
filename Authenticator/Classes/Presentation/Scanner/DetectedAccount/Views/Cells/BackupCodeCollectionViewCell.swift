//
//  BackupCodeCollectionViewCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import UIKit

class BackupCodeCollectionViewCell: UICollectionViewCell {
    lazy var codeLable = makeLabel()
    lazy var deleteButton = makeButton()
    private var didTapDelete: ((String) -> Void)?
    private var code = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white.withAlphaComponent(0.08)
        layer.cornerRadius = 20.scale
        clipsToBounds = true
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension BackupCodeCollectionViewCell {
    func setup(code: String, didTapDelete: @escaping (String) -> Void) {
        self.didTapDelete = didTapDelete
        self.code = code
        
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        codeLable.attributedText = code.separated().attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension BackupCodeCollectionViewCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            codeLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.scale),
            codeLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            codeLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 16.scale),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: codeLable.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: codeLable.trailingAnchor, constant: 8.scale),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension BackupCodeCollectionViewCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.addTarget(self, action: #selector(deleteCode), for: .touchUpInside)
        view.setImage(UIImage(named: "Scan.Delete"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

private extension BackupCodeCollectionViewCell {
    @objc func deleteCode() {
        didTapDelete?(code)
    }
}
