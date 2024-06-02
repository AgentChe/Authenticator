//
//  LearnMoreHeaderView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit

final class LearnMoreHeaderView: UIView {
    
    lazy var closeButton = makeCloseButton()
    lazy var learnMoreButton = makeLearnMoreButton()
    lazy var imageView = makeImageView()
    lazy var titleView = makeTitleView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 16.scale
        backgroundColor = Appearance.black2
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension LearnMoreHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 44.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44.scale),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.584)
        ])
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18.scale),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            learnMoreButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16.scale),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 48.scale),
            learnMoreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 112.scale),
            learnMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -112.scale),
            learnMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18.scale),
            closeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LearnMoreHeaderView {
    func makeLearnMoreButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.black)
            .textAlignment(.center)
        let attrsTitle = "Accounts.LearnMore".localized.attributed(with: attrs)
        
        let view = UIButton()
        view.setAttributedTitle(attrsTitle, for: .normal)
        view.layer.cornerRadius = 24.scale
        view.backgroundColor = Appearance.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Accounts.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Accounts.LearnMore")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 20.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Accounts.HowToSetup".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

