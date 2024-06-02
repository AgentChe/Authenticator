//
//  MenuViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 25.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    
    lazy var mainView = MenuView()
    private lazy var viewModel = MenuViewModel()
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: .init(
            selectedElement: mainView.collectionView.selectedElement.asSignal(),
            didTapLearnMore: mainView.collectionView.learnMoreAction.asSignal(),
            biometryIsOn: mainView.collectionView.isOnRelay.asSignal()
        ))
        
        output.elements
            .drive(with: mainView.collectionView) { $0.setup(elements: $1) }
            .disposed(by: disposeBag)
        
        output.route
            .emit(with: self) { $0.route(route: $1) }
            .disposed(by: disposeBag)
    }
}

private extension MenuViewController {
    func route(route: MenuViewModel.Route) {
        switch route {
        case .learnMore:
            showLearnMore()
        case .password:
            showPassword()
        case let .open(url):
            open(url: url)
        }
    }
    
    func showLearnMore() {
        
    }
    
    func showPassword() {
        let vc = PasswordViewController.make()
        present(vc, animated: true)
    }
    
    func open(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
