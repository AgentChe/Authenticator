//
//  DetectedAccountViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

class DetectedAccountViewController: UIViewController {

    lazy var mainView = DetectedAccountView()
    private let viewModel: DetectedAccountViewModel
    private let disposeBag = DisposeBag()
    private lazy var addedBackupCodeRelay = PublishRelay<String>()
    
    private var didClose: (() -> Void)?
    
    init(token: TokenModel) {
        viewModel = .init(token: token)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeAction = UIBarButtonItem()
        closeAction.image = UIImage(named: "Close")
        navigationItem.rightBarButtonItem = closeAction
        
        let output = viewModel.confiure(input: .init(
            didTapSave: mainView.saveButton.rx.tap.asSignal(),
            didTapAddCodes: mainView.collectionView.didTapAddRelay.asSignal(),
            didTapClose: closeAction.rx.tap.asSignal(),
            addBackupCode: addedBackupCodeRelay.asSignal(),
            deleteCode: mainView.collectionView.deleteCodeRelay.asSignal()
        ))
        
        output.elements
            .drive(with: mainView.collectionView) { $0.setup(elements: $1) }
            .disposed(by: disposeBag)
        
        output.route
            .emit(with: self) { $0.route(route: $1) }
            .disposed(by: disposeBag)
    }
    
    deinit {
        didClose?()
    }
}

extension DetectedAccountViewController {
    static func make(token: TokenModel, didClose: @escaping () -> Void) -> NavigationController {
        let vc = DetectedAccountViewController(token: token)
        vc.didClose = didClose
        let nc = NavigationController(rootViewController: vc)
        return nc
    }
}

private extension DetectedAccountViewController {
    func route(route: DetectedAccountViewModel.Route) {
        switch route {
        case .addCode:
            showAddCodes()
        case .close:
            dismiss(animated: true)
        case .paygate:
            showPaygate()
        }
    }
    
    func showAddCodes() {
        let vc = AddBackupCodeViewController.make { [weak self] in
            self?.addedBackupCodeRelay.accept($0)
        }
        present(vc, animated: true)
    }
    
    func showPaygate() {
        let vc = PaygateViewController.make()
        present(vc, animated: true)
    }
}
