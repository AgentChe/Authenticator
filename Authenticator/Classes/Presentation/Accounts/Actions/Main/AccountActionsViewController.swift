//
//  AccountActionsViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 08.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class AccountActionsViewController: UIViewController {
    
    lazy var mainView = AccountActionsView()
    
    private var selectedAction: ((AccountAction) -> Void)?
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Signal
            .merge(
                mainView.editAction.rx.tap.asSignal().map { .edit },
                mainView.deleteAction.rx.tap.asSignal().map { .delete }
            )
            .emit(with: self) { $0.selectedAction?($1) }
            .disposed(by: disposeBag)
    }
    
}

extension AccountActionsViewController {
    static func make(model: TokenModel, selectedAction: @escaping (AccountAction) -> Void) -> AccountActionsViewController {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 18.scale))
            .lineHeight(25.2.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let vc = AccountActionsViewController()
        vc.selectedAction = selectedAction
        vc.mainView.titleView.attributedText = model.issuer.attributed(with: attrs)
        return vc
    }
}
