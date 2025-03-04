//
//  AuthenticationViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 15.05.2024.
//

import UIKit
import RxSwift

final class AuthenticationViewController: UIViewController {
    lazy var mainView = AuthenticationView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = AuthenticationViewModel()
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.passwordField.becomeFirstResponder()
        
        let output = viewModel.configure(input: .init(
            password: mainView.passwordField.rx.text.compactMap { $0 },
            editingEnd: mainView.passwordField.rx.controlEvent(.editingDidEndOnExit).asSignal(), 
            didBeginEditing: mainView.passwordField.rx.controlEvent(.editingDidBegin).asSignal(),
            didTapBiometry: mainView.fieldButton.rx.tap.asSignal()
        ))
        
        output.biometryType
            .drive(with: mainView) { $0.setup(for: $1) }
            .disposed(by: disposeBag)
        
        output.isShowError
            .drive(with: mainView) { $0.errorState(isShow: $1) }
            .disposed(by: disposeBag)
        
        output.authorized
            .emit(with: self) { base, _ in base.goNext() }
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension AuthenticationViewController {
    static func make() -> AuthenticationViewController {
        let vc = AuthenticationViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension AuthenticationViewController {
    func goNext() {
        let nc = NavigationController(rootViewController: MainViewController.make(requestReview: false))
        nc.setNavigationBarHidden(true, animated: false)
        
        if SessionManager().hasActiveSubscriptions() {
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = nc
        } else {
            let vc = PaygateViewController.make {
                UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = nc
            }
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = vc
        }
    }
}
