//
//  OPageIndicatorView.swift
//  Authenticator
//
//  Created by Андрей Чернышев on 25.04.2024.
//

import UIKit

final class OPageIndicatorView: UIView {
    lazy var indicator1 = makeIndicatorView()
    lazy var indicator2 = makeIndicatorView()
    lazy var indicator3 = makeIndicatorView()
    
    lazy var page = 1 {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OPageIndicatorView {
    func update() {
        indicator1.backgroundColor = Appearance.custom_152_210_139.withAlphaComponent(page == 1 ? 1 : 0.4)
        indicator2.backgroundColor = Appearance.custom_152_210_139.withAlphaComponent(page == 2 ? 1 : 0.4)
        indicator3.backgroundColor = Appearance.custom_152_210_139.withAlphaComponent(page == 3 ? 1 : 0.4)
    }
}

// MARK: Make constraints
private extension OPageIndicatorView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            indicator1.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicator1.topAnchor.constraint(equalTo: topAnchor),
            indicator1.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator1.widthAnchor.constraint(equalToConstant: 8.scale),
            indicator1.heightAnchor.constraint(equalToConstant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            indicator2.leadingAnchor.constraint(equalTo: indicator1.trailingAnchor, constant: 8.scale),
            indicator2.topAnchor.constraint(equalTo: topAnchor),
            indicator2.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator2.widthAnchor.constraint(equalToConstant: 8.scale),
            indicator2.heightAnchor.constraint(equalToConstant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            indicator3.leadingAnchor.constraint(equalTo: indicator2.trailingAnchor, constant: 8.scale),
            indicator3.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicator3.topAnchor.constraint(equalTo: topAnchor),
            indicator3.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator3.widthAnchor.constraint(equalToConstant: 8.scale),
            indicator3.heightAnchor.constraint(equalToConstant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OPageIndicatorView {
    func makeIndicatorView() -> CircleView {
        let view = CircleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
