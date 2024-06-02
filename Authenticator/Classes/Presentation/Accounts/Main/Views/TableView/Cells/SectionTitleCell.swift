//
//  SectionTitleCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit

final class SectionTitleCell: UITableViewCell {
    
    lazy var titleView = makeTitleView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SectionTitleCell {
    func setup(title: String) {
        titleView.attributedText = title.attributed(with: .attrs)
    }
}

// MARK: Private
private extension SectionTitleCell {
    func initialize() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SectionTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate( [
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SectionTitleCell {
    func makeTitleView() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let attrs = TextAttributes()
        .font(Fonts.Inter.semiBold(size: 18.scale))
        .lineHeight(22.5.scale)
        .textColor(Appearance.white)
        .textAlignment(.left)
}
