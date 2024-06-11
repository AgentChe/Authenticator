//
//  HowToSetupViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 11.06.2024.
//

import UIKit
import RxSwift

final class HowToSetupViewController: UIViewController {
    lazy var mainView = HowToSetupView()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView
            .setup(elements: SetupServiceModel.allCases)
        
        mainView.closeButton.rx.tap
            .asSignal()
            .emit(with: self) { base, _ in
                base.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.selectedService
            .asSignal()
            .emit(with: self) {
                $0.showDocument(service: $1)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension HowToSetupViewController {
    static func make() -> NavigationController {
        let vc = HowToSetupViewController()
        let nc = NavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        nc.setNavigationBarHidden(true, animated: false)
        return nc
    }
}

private extension HowToSetupViewController {
    func showDocument(service: SetupServiceModel) {
        let vc = InstructionViewController.make(service: service)
        present(vc, animated: true)
    }
}
