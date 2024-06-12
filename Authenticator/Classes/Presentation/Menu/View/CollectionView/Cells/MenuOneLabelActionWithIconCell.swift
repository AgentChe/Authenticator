//
//  MenuOneLabelActionWithIconCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 20.05.2024.
//

import UIKit

class MenuOneLabelActionWithIconCell: UICollectionViewCell {
    private lazy var iconView = makeIconView()
    private lazy var titleView = makeTitleView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MenuOneLabelActionWithIconCell {
    func setup(action: MenuSection.ActionWithIcon) {
        let attrs = TextAttributes()
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        titleView.attributedText = action.title.attributed(with: attrs)
        iconView.image = action.icon
    }
}

// MARK: Make constraints
private extension MenuOneLabelActionWithIconCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12.scale),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuOneLabelActionWithIconCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleView() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
