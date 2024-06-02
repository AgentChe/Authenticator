//
//  SearchAccountViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 19.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchAccountViewController: UIViewController {
    lazy var mainView = SearchAccountView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: SearchAccountViewModel
    
    private let presentationDelegate = BottomSheetTransitionDelegate()
    private let selectedAction = PublishRelay<(AccountAction, TokenModel)>()
    private let didTapDelete = PublishRelay<TokenModel>()
    
    init(models: [TOTPModel]) {
        viewModel = .init(models: models)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.searchField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchText = mainView.searchField.rx.text.map { $0 ?? "" }
        let output = viewModel.configure(input: .init(
            searchText: searchText,
            didTapAccountMore: mainView.tableView.didTapMore.asSignal(),
            selectedAction: selectedAction.asSignal(),
            deleteSignal: didTapDelete.asSignal()
        ))
        
        output.elements
            .drive(with: mainView.tableView) { $0.setup(elements: $1) }
            .disposed(by: disposeBag)
        
        output.elements
            .drive(with: mainView) { $0.setup(isEmpty: $1.isEmpty) }
            .disposed(by: disposeBag)
        
        output.route
            .emit(with: self) { $0.route(route: $1) }
            .disposed(by: disposeBag)
        
        mainView.cancelButton.rx.tap
            .asSignal()
            .emit(with: self) { base, _ in
                base.mainView.searchField.endEditing(true)
                base.mainView.showCancel(isShow: false) { [weak base] in
                    base?.dismiss(animated: false)
                }
            }
            .disposed(by: disposeBag)
        
        mainView.searchField.rx.controlEvent(.editingDidBegin)
            .asSignal()
            .map { true }
            .distinctUntilChanged()
            .emit(with: mainView) {
                $0.showCancel(isShow: $1)
            }
            .disposed(by: disposeBag)
        
        searchText
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: true)
            .drive(with: mainView.searchField) { $0.rightViewMode = $1 ? .never : .whileEditing }
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SearchAccountViewController {
    static func make(models: [TOTPModel]) -> NavigationController {
        let vc = SearchAccountViewController(models: models)
        let nc = NavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        return nc
    }
}

private extension SearchAccountViewController {
    func route(route: SearchAccountViewModel.Route) {
        switch route {
        case let .action(model):
            showAction(for: model)
        case let .delete(model):
            showDelete(for: model)
        case let .edit(model):
            showEdit(for: model)
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
}
