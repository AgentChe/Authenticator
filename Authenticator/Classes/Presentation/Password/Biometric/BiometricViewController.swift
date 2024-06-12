//
//  BiometricViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 12.05.2024.
//

import UIKit
import RxSwift

final class BiometricViewController: UIViewController {
    lazy var mainView = BiometricView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = BiometricViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeAction = UIBarButtonItem()
        closeAction.image = UIImage(named: "Close")
        navigationItem.rightBarButtonItem = closeAction
        
        let output = viewModel.configure(input: .init(
            didTapAction: mainView.actionButton.rx.tap.asSignal(),
            didTapSkip: mainView.skipButton.rx.tap.asSignal(),
            didTapClose: closeAction.rx.tap.asSignal()
        ))
        
        output.route
            .emit(with: self) { $0.route(route: $1) }
            .disposed(by: disposeBag)
    }
}
    
private extension BiometricViewController {
    func route(route: BiometricViewModel.Route) {
        switch route {
        case .dismiss:
            dismiss(animated: true)
        }
    }
}

// MARK: Make
extension BiometricViewController {
    static func make(_ biometryType: BiometryType) -> NavigationController {
        let vc = BiometricViewController()
        let nc = NavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        vc.mainView.setup(for: biometryType)
        return nc
    }
}
