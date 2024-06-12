//
//  AccountDeleteActionViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 08.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class AccountDeleteActionViewController: UIViewController {
    
    lazy var mainView = AccountDeleteActionView()
    
    private var didTapDelete: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.cancelButton.rx.tap
            .asSignal()
            .emit(with: self) { base, _ in
                base.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.deleteButton.rx.tap
            .asSignal()
            .emit(with: self) { base, _ in
                base.didTapDelete?()
            }
            .disposed(by: disposeBag)
    }
}

extension AccountDeleteActionViewController {
    static func make(didTapDelete: @escaping () -> Void) -> AccountDeleteActionViewController {
        let vc = AccountDeleteActionViewController()
        vc.didTapDelete = didTapDelete
        return vc
    }
}
