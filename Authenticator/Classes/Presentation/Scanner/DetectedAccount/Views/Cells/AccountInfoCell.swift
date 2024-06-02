//
//  AccountInfoCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import UIKit

class AccountInfoCell: UICollectionViewCell {
    lazy var iconView = makeImage()
    lazy var successLabel = makeSuccessLabel()
    lazy var titleView = makeTitle()
    lazy var subtitleView = makeSubtitle()
    private lazy var stackView = makeStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AccountInfoCell {
    func setup(model: TokenModel, isSaved: Bool = true) {
        successLabel.isHidden = !isSaved
        titleView.isHidden = model.issuer.isEmpty
        subtitleView.isHidden = model.userName.isEmpty
        titleView.attributedText = model.issuer.attributed(with: .titleAttrs)
        subtitleView.attributedText = model.userName.attributed(with: .subtitleAttrs)
    }
}

// MARK: Private
private extension AccountInfoCell {
    func initialize() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        [successLabel, titleView, subtitleView].forEach(stackView.addArrangedSubview)
    }
}

// MARK: Make constraints
private extension AccountInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 60.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16.scale),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AccountInfoCell {
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8.scale
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImage() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Accounts.IconPlaceholder")
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitle() -> UILabel {
        let view = UILabel()
        return view
    }
    
    func makeSuccessLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(25.2.scale)
            .textColor(Appearance.primary)
            .textAlignment(.center)
        
        let attrsString = NSMutableAttributedString()
        if let image = UIImage(named: "Scan.AccountAdded") {
            let imageAttachment = NSTextAttachment(image: image)
            attrsString.append(.init(attachment: imageAttachment))
        }
        attrsString.append(" ".attributed(with: attrs))
        attrsString.append("Scan.AccountAdded".localized.attributed(with: attrs))
        
        let view = UILabel()
        view.attributedText = attrsString
        view.isHidden = true
        return view
    }
    
    func makeSubtitle() -> UILabel {
        let view = UILabel()
        view.alpha = 0.8
        return view
    }
}

private extension TextAttributes {
    static let titleAttrs = TextAttributes()
        .font(Fonts.Inter.semiBold(size: 18.scale))
        .lineHeight(25.2.scale)
        .textColor(Appearance.white)
        .textAlignment(.center)
    
    static let subtitleAttrs = TextAttributes()
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(22.4.scale)
        .textColor(Appearance.white)
        .textAlignment(.center)
}
