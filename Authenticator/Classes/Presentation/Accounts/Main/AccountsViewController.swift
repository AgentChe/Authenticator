//
//  AccountsViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 25.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

class AccountsViewController: UIViewController {
    
    lazy var mainView = AccountsView()
    private lazy var viewModel = AccountsViewModel()
    
    private let selectedAction = PublishRelay<(AccountAction, TokenModel)>()
    private let didTapDelete = PublishRelay<TokenModel>()
    private let disposeBag = DisposeBag()
    
    private let presentationDelegate = BottomSheetTransitionDelegate()
    private let searchTest = SearchTransitionDelegate()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: .init(
            didTapCloseSetupPassword: mainView.tableView.didTapCloseSetupPassword.asSignal(),
            didTapLearnMore: mainView.learnMoreView.learnMoreButton.rx.tap.asSignal(),
            didTapCloseLearnMore: mainView.learnMoreView.closeButton.rx.tap.asSignal(),
            didTapAccountMore: mainView.tableView.didTapMore.asSignal(),
            didTapAdd: mainView.tableView.didTapAdd.asSignal(),
            selectedAction: selectedAction.asSignal(),
            deleteSignal: didTapDelete.asSignal(), 
            didSelectItem: mainView.tableView.didSelectItem.asSignal()
        ))
        
        output.elements
            .drive(with: mainView.tableView) {
                $0.setup(elements: $1)
            }
            .disposed(by: disposeBag)
        
        output.isShowLearnMore
            .drive(with: mainView) {
                $0.updateConstraint(isShow: $1)
            }
            .disposed(by: disposeBag)
        
        output.route
            .emit(with: self) { $0.route(route: $1) }
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(with: mainView) { $0.setup(isLoading: $1) }
            .disposed(by: disposeBag)
    }
}

private extension AccountsViewController {
    
    func route(route: AccountsViewModel.Route) {
        switch route {
        case let .action(model):
            showAction(for: model)
        case let .delete(model):
            showDelete(for: model)
        case let .edit(model):
            showEdit(for: model)
        case .scan:
            showAdd()
        case let .search(models):
            showSearch(models: models)
        case .setupPassword:
            showPassword()
        case let .error(error):
            showError(error: error)
        case .learnMore:
            showLearnMore()
        }
    }
    
    func showAction(for model: TokenModel) {
        let vc = AccountActionsViewController.make(model: model) { [weak self] action in
            self?.dismiss(animated: true) { [weak self] in
                self?.selectedAction.accept((action, model))
            }
        }
        
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = presentationDelegate
        
        present(vc, animated: true)
    }
    
    func showDelete(for model: TokenModel) {
        let vc = AccountDeleteActionViewController.make { [weak self] in
            self?.dismiss(animated: true) { [weak self] in
                self?.didTapDelete.accept(model)
            }
        }
        
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = presentationDelegate
        
        present(vc, animated: true)
    }
    
    func showEdit(for model: TokenModel) {
        let nc = CreateOrEditViewController.make(tokenModel: model)
        present(nc, animated: true)
    }
    
    func showSearch(models: [TOTPModel]) {
        let nc = SearchAccountViewController.make(models: models)
        nc.modalPresentationStyle = .custom
        nc.transitioningDelegate = searchTest
        present(nc, animated: false)
    }
    
    func showPassword() {
        let vc = PasswordViewController.make()
        present(vc, animated: true)
    }
    
    func showAdd() {
        MainCoordinatorMediator.shared.updateTab(tab: .scan)
    }
    
    func showError(error: Error) {
        let vc = TryAgainViewController.make(error: error)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func showLearnMore() {
        let vc = HowToSetupViewController.make()
        present(vc, animated: true)
    }
}
