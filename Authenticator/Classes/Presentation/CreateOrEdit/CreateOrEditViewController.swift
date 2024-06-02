//
//  CreateOrEditViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 04.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class CreateOrEditViewController: UIViewController {
    
    lazy var mainView = CreateOrEditView()
    private let viewModel: CreateOrEditViewModel
    
    private let disposeBag = DisposeBag()
    
    private lazy var addedBackupCodeRelay = PublishRelay<String>()
    
    init(tokenModel: TokenModel?) {
        viewModel = .init(token: tokenModel)
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
        
        let output = viewModel.configure(input: .init(
            didTapSave: mainView.saveButton.rx.tap.asSignal(),
            didTapAddCodes: mainView.collectionView.didTapAddRelay.asSignal(),
            didTapClose: closeAction.rx.tap.asSignal(),
            addBackupCode: addedBackupCodeRelay.asSignal(),
            deleteCode: mainView.collectionView.deleteCodeRelay.asSignal(), 
            changeFields: mainView.collectionView.fieldValueRelay.asSignal()
        ))
        
        output.elements
            .drive(with: mainView.collectionView) { $0.setup(elements: $1) }
            .disposed(by: disposeBag)
        
        output.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.route
            .emit(with: self) { $0.route(route: $1) }
            .disposed(by: disposeBag)
        
        output.saveIsEnabled
            .drive(with: mainView.saveButton) {
                $0.isEnabled = $1
                $0.alpha = $1 ? 1 : 0.4
            }
            .disposed(by: disposeBag)
    }
}

extension CreateOrEditViewController {
    static func make(tokenModel: TokenModel? = nil) -> NavigationController {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 18.scale))
            .lineHeight(25.2.scale)
            .textColor(Appearance.white)
        
        let vc = CreateOrEditViewController(tokenModel: tokenModel)
        let nc = NavigationController(rootViewController: vc)
        nc.navigationBar.titleTextAttributes = attrs.dictionary
        
        return nc
    }
}

private extension CreateOrEditViewController {
    func route(route: CreateOrEditViewModel.Route) {
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
