//
//  OtherMethodsView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import UIKit

class OtherMethodsView: UIView {

    lazy var grabberView = makeGrabberView()
    lazy var titleView = makeTitleView()
    lazy var stackView = makeStackView()
    lazy var manualButton = makeOtherMethodButton()
    lazy var photoButton = makeOtherMethodButton()
    lazy var filesButton = makeOtherMethodButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OtherMethodsView {
    func initialize() {
        layer.cornerRadius = 16.scale
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = Appearance.black
        
        [manualButton, photoButton, filesButton].forEach(stackView.addArrangedSubview)
        
        manualButton.setup(title: "Scan.Manual".localized, image: UIImage(named: "Scan.Manual"))
        photoButton.setup(title: "Scan.Photo".localized, image: UIImage(named: "Scan.Photo"))
        filesButton.setup(title: "Scan.File".localized, image: UIImage(named: "Scan.File"))
    }
}

// MARK: Make constraints
private extension OtherMethodsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            grabberView.heightAnchor.constraint(equalToConstant: 4.scale),
            grabberView.widthAnchor.constraint(equalToConstant: 32.scale),
            grabberView.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            grabberView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: grabberView.bottomAnchor, constant: 24.scale),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24.scale),
            stackView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OtherMethodsView {
    func makeGrabberView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 2.scale
        view.alpha = 0.2
        addSubview(view)
        return view
    }
    
    func makeTitleView() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 18.scale))
            .lineHeight(25.2)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Scan.OtherMethods".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOtherMethodButton() -> OtherMethodButton {
        let view = OtherMethodButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
