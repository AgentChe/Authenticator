//
//  PasswordViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 10.05.2024.
//

import UIKit
import RxCocoa
import RxSwift

class PasswordViewController: UIViewController {
    
    lazy var mainView = PasswordView()
    private lazy var viewModel = PasswordViewModel()
    private let disposeBag = DisposeBag()
    
    private var didClose: (() -> Void)?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.passwordField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let output = viewModel.configure(input: .init(
            didTapSkip: mainView.skipButton.rx.tap.asSignal(),
            passwordValue: mainView.passwordField.rx.text.asObservable(),
            didTapNext: mainView.nextButton.rx.tap.asSignal(),
            didTapBiometry: mainView.fieldButton.rx.tap.asSignal()
        ))
        
        output.screenState
            .drive(with: mainView) { $0.setup(for: $1) }
            .disposed(by: disposeBag)
        
        output.biometryType
            .drive(with: mainView) { $0.setup(for: $1) }
            .disposed(by: disposeBag)
        
        output.route
            .emit(with: self) { $0.route(route: $1) }
            .disposed(by: disposeBag)
        
        output.isShowError
            .emit(with: mainView) { $0.errorState(isShow: $1) }
            .disposed(by: disposeBag)
        
        output.clearField
            .map { "" }
            .emit(to: mainView.passwordField.rx.text)
            .disposed(by: disposeBag)
    }
    
    deinit {
        didClose?()
    }
}

extension PasswordViewController {
    static func make(didClose: (() -> Void)? = nil) -> NavigationController {
        let vc = PasswordViewController()
        vc.didClose = didClose
        let nc = NavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        nc.modalPresentationStyle = .fullScreen
        return nc
    }
}

private extension PasswordViewController {
    func route(route: PasswordViewModel.Route) {
        switch route {
        case .skip, .finish:
            dismiss(animated: true)
        case let .biometric(type):
            showBiometric(type: type)
        }
    }
    
    func showBiometric(type: BiometryType) {
        let vc = BiometricViewController.make(type)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
