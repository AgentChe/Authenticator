//
//  SetupServiceViewCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 11.06.2024.
//

import UIKit

class SetupServiceViewCell: UITableViewCell {
    
    lazy var nameView = makeNameView()
    lazy var iconView = makeIconView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SetupServiceViewCell {
    func setup(service: SetupServiceModel) {
        let attrs = TextAttributes()
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        nameView.attributedText = service.name.attributed(with: attrs)
        iconView.image = service.icon ?? UIImage(named: "Services.Placeholder")
    }
}

// MARK: Make constraints
private extension SetupServiceViewCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 48.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            nameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SetupServiceViewCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.scale
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameView() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
