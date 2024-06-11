//
//  HowToSetupView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 11.06.2024.
//
import UIKit

final class HowToSetupView: UIView {
    
    lazy var closeButton = makeCloseButton()
    lazy var imageView = makeImageView()
    lazy var titleView = makeTitleView()
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Appearance.black2
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension HowToSetupView {
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
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18.scale),
            closeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16.scale),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HowToSetupView {
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
    
    func makeTableView() -> HowToSetupTableView {
        let view = HowToSetupTableView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}


#if DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct HowToSetupView_Previews: PreviewProvider {
    
    struct HowToSetupRepresentable: UIViewRepresentable {
        func makeUIView(context: Context) -> HowToSetupView {
            let view = HowToSetupView()
            return view
        }
        func updateUIView(_ uiView: HowToSetupView, context: Context) {
            
        }
    }

    static var previews: some View {
        return HowToSetupRepresentable().frame(width: 343, height: 165, alignment: .center)
    }
}
#endif
