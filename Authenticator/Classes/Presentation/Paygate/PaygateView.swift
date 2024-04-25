//
//  PaygateView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit

final class PaygateView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var imageView = makeImageView()
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(text: "Paygate.Cell1".localized)
    lazy var cell2 = makeCell(text: "Paygate.Cell2".localized)
    lazy var cell3 = makeCell(text: "Paygate.Cell3".localized)
    lazy var leftOptionButton = makeProductButton()
    lazy var rightOptionButton = makeProductButton()
    lazy var continueButton = makeContinueButton()
    lazy var infoLabel = makeInfoLabel()
    lazy var termsOfServiceButton = makeTermsOfServiceButton()
    lazy var privacyPolicyButton = makePrivacyPolicyButton()
    lazy var restoreButton = makeRestoreButton()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension PaygateView {
    @objc
    func productTapped(sender: UIButton) {
        guard let productButton = sender as? PaygateProductButton else {
            return
        }
        
        [leftOptionButton, rightOptionButton].forEach { $0.isChecked = false }
        
        productButton.isChecked = true
    }
}

// MARK: Make constraints
private extension PaygateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 175.scale : 141.scale),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 211.scale : 171.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 59.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 14.scale : 0)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 14.scale : 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 12.scale : 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 12.scale : 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftOptionButton.widthAnchor.constraint(equalToConstant: 161.scale),
            leftOptionButton.heightAnchor.constraint(equalToConstant: 185.scale),
            leftOptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            leftOptionButton.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 24.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightOptionButton.widthAnchor.constraint(equalToConstant: 161.scale),
            rightOptionButton.heightAnchor.constraint(equalToConstant: 185.scale),
            rightOptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            rightOptionButton.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 24.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            continueButton.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 68.scale : 59.scale),
            continueButton.topAnchor.constraint(equalTo: rightOptionButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfServiceButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27.scale),
            termsOfServiceButton.heightAnchor.constraint(equalToConstant: 14.scale),
            termsOfServiceButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 35.scale : 19.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 141.scale),
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: 14.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 35.scale : 19.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 249.scale),
            restoreButton.heightAnchor.constraint(equalToConstant: 14.scale),
            restoreButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 35.scale : 19.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Background")
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: ScreenSize.isIphoneXFamily ? "Paygate.Image.X" : "Paygate.Image.8")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 24.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Paygate.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(text: String) -> PaygateInfoCell {
        let view = PaygateInfoCell()
        view.setup(text: text)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProductButton() -> PaygateProductButton {
        let view = PaygateProductButton()
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 2.scale
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(productTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInfoLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white.withAlphaComponent(0.6))
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(14.4.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.Info".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTermsOfServiceButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 12.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.TermsOfUse".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePrivacyPolicyButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 12.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.PrivacyPolicy".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRestoreButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 12.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.RestorePurchases".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
