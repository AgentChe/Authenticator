//
//  TOTPCodeView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit
import Toast_Swift

final class TOTPCodeView: UIView {
    
    lazy var codeLabel = makeCodeView()
    lazy var subtitleLabel = makeSubtitle()
    lazy var copyButton = makeCopyButton()
    lazy var timeLabel = makeTimeLabel()
    
    private var currentCode: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TOTPCodeView {
    func setup(time seconds: Int) {
        let format = "%02d:%02d"
        
        let mins = seconds / 60
        let sec = seconds - mins * 60
        
        let time = String(format: format, mins, sec)
        timeLabel.attributedText = time.attributed(with: .timeAttrs)
    }
    
    func setup(code: String) {
        currentCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        codeLabel.attributedText = code.attributed(with: .codeAttrs)
    }
}

// MARK: Private
private extension TOTPCodeView {
    @objc func copyCode() {
        UIApplication.shared.keyWindow?.makeToast("Toast.Passcode".localized, duration: 1, position: .top)
        UIPasteboard.general.string = currentCode
    }
}

private extension TOTPCodeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            codeLabel.topAnchor.constraint(equalTo: topAnchor),
            codeLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            copyButton.centerYAnchor.constraint(equalTo: codeLabel.centerYAnchor),
            copyButton.leadingAnchor.constraint(equalTo: codeLabel.trailingAnchor, constant: 8),
            copyButton.heightAnchor.constraint(equalToConstant: 24),
            copyButton.widthAnchor.constraint(equalTo: copyButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

private extension TOTPCodeView {
    func makeCodeView() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitle() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .textColor(Appearance.white)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Passcode".localized.attributed(with: attrs)
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTimeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCopyButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.4
        view.addTarget(self, action: #selector(copyCode), for: .touchUpInside)
        view.setImage(UIImage(named: "Copy"), for: .normal)
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let timeAttrs = TextAttributes()
        .font(Fonts.Inter.medium(size: 16.scale))
        .lineHeight(22.4.scale)
        .textColor(Appearance.white)
        .textAlignment(.right)
    
    static let codeAttrs = TextAttributes()
        .font(Fonts.Inter.medium(size: 32.scale))
        .lineHeight(38.4.scale)
        .textColor(Appearance.white)
        .textAlignment(.left)
}
