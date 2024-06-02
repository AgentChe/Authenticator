//
//  MenuLearnMoreViewCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 10.05.2024.
//

import UIKit

class MenuLearnMoreViewCell: UICollectionViewCell {
    
    lazy var button = makeButton()
    private lazy var titleView = makeTitleView()
    private lazy var imageView = makeImage()
    
    private var learnMoreAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Appearance.black2
        contentView.layer.cornerRadius = 16.scale
        contentView.clipsToBounds = true
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MenuLearnMoreViewCell {
    func setup(action: @escaping () -> Void) {
        learnMoreAction = action
    }
}

// MARK: Make constraints
private extension MenuLearnMoreViewCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            titleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 33.scale),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44.scale),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44.scale),
        ])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16.scale),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 96.scale),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -96.scale),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -76.scale),
            button.heightAnchor.constraint(equalToConstant: 47.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuLearnMoreViewCell {
    func makeTitleView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 20.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Menu.LearnMoreTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.black)
            .textAlignment(.center)
        let attrsTitle = "Menu.LearnMore".localized.attributed(with: attrs)
        
        let view = UIButton()
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.setAttributedTitle(attrsTitle, for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImage() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Menu.Header")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}


private extension MenuLearnMoreViewCell {
    @objc func buttonAction() {
        learnMoreAction?()
    }
}
