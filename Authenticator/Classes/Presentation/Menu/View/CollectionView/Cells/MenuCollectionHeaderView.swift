//
//  MenuCollectionHeaderView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 10.05.2024.
//

import UIKit

class MenuCollectionHeaderView: UICollectionReusableView {
    private lazy var titleView = makeTitleView()
    
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
extension MenuCollectionHeaderView {
    func setup(type: MenuSection.SectionType) {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 18.scale))
            .lineHeight(25.2.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        titleView.attributedText = type.title.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension MenuCollectionHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topAnchor),
            titleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuCollectionHeaderView {
    func makeTitleView() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension MenuSection.SectionType {
    var title: String {
        switch self {
        case .account:
            return "Menu.AccountSection".localized
        case .about:
            return "Menu.AboutSection".localized
        case .setup:
            return ""
        }
    }
}
