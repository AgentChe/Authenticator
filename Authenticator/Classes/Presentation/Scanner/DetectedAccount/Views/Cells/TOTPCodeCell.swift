//
//  TOTPCodeCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

class TOTPCodeCell: UICollectionViewCell {
    lazy var codeView = makeCodeView()
    lazy var progressView = makeProgressView()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
extension TOTPCodeCell {
    func setup(model: TOTPModel) {
        
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
    }
}

// MARK: Private
private extension TOTPCodeCell {
    func initialize() {
        contentView.layer.cornerRadius = 16.scale
        contentView.backgroundColor = .black.withAlphaComponent(0.3)
        contentView.clipsToBounds = true
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension TOTPCodeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            codeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            codeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            codeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: codeView.bottomAnchor, constant: 16.scale),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TOTPCodeCell {
    func makeCodeView() -> TOTPCodeView {
        let view = TOTPCodeView()
        view.setup(code: " ")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.progressTintColor = Appearance.secondary
        view.trackTintColor = .black.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

