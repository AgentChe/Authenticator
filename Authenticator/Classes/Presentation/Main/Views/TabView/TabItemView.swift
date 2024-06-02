//
//  TabItemView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 25.04.2024.
//

import UIKit

final class TabItemView: UIButton {
    enum Mode {
        case selected, deselected
    }
    
    lazy var label = makeLabel()
    lazy var iconView = makeIconView()
    
    var mode = Mode.deselected {
        didSet {
            update()
        }
    }
    
    private let name: String
    private let icon: UIImage?
    
    init(name: String, icon: UIImage?) {
        self.name = name
        self.icon = icon
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabItemView {
    func update() {
        let selected = mode == .selected
        
        let color = selected ? Appearance.primary : Appearance.white
        label.textColor = color
        iconView.tintColor = color
        alpha = selected ? 1 : 0.5
    }
}

// MARK: Make constraints
private extension TabItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 6.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabItemView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 12))
            .lineHeight(12.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = name.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = icon
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
