//
//  AccountCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit
import RxCocoa
import RxSwift

class AccountCell: UITableViewCell {
    
    lazy var iconView = makeImage()
    lazy var titleView = makeTitle()
    lazy var subtitleView = makeSubtitle()
    lazy var moreButton = makeMoreButton()
    
    lazy var titleContainer = makeTitleContainer()
    lazy var codeView = makeCodeView()
    lazy var progressView = makeProgressView()
    private lazy var containerView = makeContainer()
    
    private var didTapMore: (() -> Void)?
    
    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }
}

// MARK: Public
extension AccountCell {
    func setup(model: TOTPModel, didTapMore: @escaping () -> Void) {
        self.didTapMore = didTapMore
        model.timer
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { base, time in
                base.codeView.setup(time: time)
                base.progressView.progress = Float(time) / Float(model.model.period)
            })
            .disposed(by: disposeBag)
        
        model.code
            .startWith(" ")
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: {
                $0.codeView.setup(code: $1)
            })
            .disposed(by: disposeBag)
        
        titleView.attributedText = model.model.issuer.attributed(with: .titleAttrs)
        subtitleView.attributedText = model.model.userName.attributed(with: .subtitleAttrs)
    }
}

// MARK: Private
private extension AccountCell {
    func initialize() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    @objc func didTapMoreButton() {
        didTapMore?()
    }
}

// MARK: Make constraints
private extension AccountCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.scale),
            titleContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            titleContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 48.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            iconView.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 2.scale),
            iconView.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            moreButton.heightAnchor.constraint(equalToConstant: 24.scale),
            moreButton.widthAnchor.constraint(equalTo: moreButton.heightAnchor),
            moreButton.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            moreButton.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12.scale),
            titleView.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subtitleView.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            subtitleView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            subtitleView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            codeView.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 16.scale),
            codeView.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            codeView.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: codeView.bottomAnchor, constant: 16.scale),
            progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AccountCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 10.scale
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    func makeImage() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Accounts.IconPlaceholder")
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(view)
        return view
    }
    
    func makeTitle() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(view)
        return view
    }
    
    func makeSubtitle() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.8
        titleContainer.addSubview(view)
        return view
    }
    
    func makeMoreButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Accounts.More"), for: .normal)
        view.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(view)
        return view
    }
    
    func makeCodeView() -> TOTPCodeView {
        let view = TOTPCodeView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.progressTintColor = Appearance.secondary
        view.trackTintColor = .black.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let titleAttrs = TextAttributes()
        .font(Fonts.Inter.medium(size: 16.scale))
        .lineHeight(22.4.scale)
        .textColor(Appearance.white)
        .textAlignment(.left)
    
    static let subtitleAttrs = TextAttributes()
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(22.4.scale)
        .textColor(Appearance.white)
        .textAlignment(.left)
}
