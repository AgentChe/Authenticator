//
//  AddBackupCodeViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 30.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

class AddBackupCodeViewController: UIViewController {
    
    lazy var mainView = AddBackupCodeView()
    
    private let disposeBag = DisposeBag()
    private var didTapSave: ((String) -> Void)?
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeAction = UIBarButtonItem()
        closeAction.image = UIImage(named: "Close")
        navigationItem.leftBarButtonItem = closeAction
        navigationItem.title = "Scan.AddCodeTitle".localized
        
        mainView.textField.becomeFirstResponder()
        mainView.textField.delegate = self
        
        mainView.textField.rx.text
            .compactMap { $0 }
            .map { !$0.isEmpty }
            .startWith(false)
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: mainView.saveButton) {
                $0.isEnabled = $1
                $0.alpha = $1 ? 1 : 0.4
            }
            .disposed(by: disposeBag)
        
        mainView.saveButton.rx.tap
            .withLatestFrom(mainView.textField.rx.text)
            .compactMap { $0 }
            .subscribe(with: self) { 
                $0.didTapSave?($1.filter { !$0.isWhitespace })
                $0.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        closeAction.rx.tap
            .asSignal()
            .emit(with: self, onNext: { base, _ in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.saveButton.isHidden = true
    }
}

extension AddBackupCodeViewController {
    static func make(didTapSave: @escaping (String) -> Void) -> NavigationController {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 18.scale))
            .lineHeight(25.2.scale)
            .textColor(Appearance.white)
        
        let vc = AddBackupCodeViewController()
        let nc = NavigationController(rootViewController: vc)
        vc.didTapSave = didTapSave
        nc.modalPresentationStyle = .fullScreen
        nc.navigationBar.titleTextAttributes = attrs.dictionary
        
        return nc
    }
}

extension AddBackupCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        CreateOrEditFieldFormatter.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}
