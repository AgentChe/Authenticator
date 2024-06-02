//
//  MenuOneLabelActionCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 10.05.2024.
//

import UIKit

class MenuOneLabelActionCell: UICollectionViewCell {
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
extension MenuOneLabelActionCell {
    func setup(action: MenuSection.ActionType) {
        let attrs = TextAttributes()
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        titleView.attributedText = action.title.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension MenuOneLabelActionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuOneLabelActionCell {
    func makeTitleView() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
