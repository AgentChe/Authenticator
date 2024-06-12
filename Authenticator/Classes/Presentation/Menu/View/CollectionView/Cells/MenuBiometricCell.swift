//
//  MenuBiometricCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 10.05.2024.
//

import UIKit

class MenuBiometricCell: UICollectionViewCell {
    lazy var iconView = makeIconView()
    lazy var titleView = makeTitleView()
    lazy var subtitleView = makeSubtitleView()
    lazy var switchView = makeSwitchView()
    
    private var isOnAction: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MenuBiometricCell {
    func setup(type: BiometryType, isOn: Bool, isOnAction: @escaping (Bool) -> Void) {
        let titleAttrs = TextAttributes()
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        let subtitleAttrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        self.isOnAction = isOnAction
        titleView.attributedText = type.title.attributed(with: titleAttrs)
        subtitleView.attributedText = type.subtitle.attributed(with: subtitleAttrs)
        iconView.image = type.icon
        switchView.isOn = isOn
    }
}

// MARK: Make constraints
private extension MenuBiometricCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            switchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchView.leadingAnchor.constraint(equalTo: titleView.trailingAnchor, constant:  16.scale),
            switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8.scale),
            subtitleView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            subtitleView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            subtitleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuBiometricCell {
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
    
    func makeSubtitleView() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSwitchView() -> UISwitch {
        let view = UISwitch()
        view.onTintColor = Appearance.primary
        view.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

private extension MenuBiometricCell {
    @objc func changeSwitch(sender: UISwitch) {
        isOnAction?(sender.isOn)
    }
}

private extension BiometryType {
    var title: String {
        switch self {
        case .faceID:
            return "Menu.FaceID".localized
        case .touchID:
            return "Menu.TouchID".localized
        }
    }
    
    var subtitle: String {
        switch self {
        case .faceID:
            return "Menu.FaceIDSubtitle".localized
        case .touchID:
            return "Menu.TouchIDSubtitle".localized
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .faceID:
            return UIImage(named: "Menu.FaceID")
        case .touchID:
            return UIImage(named: "Menu.TouchID")
        }
    }
}
