//
//  OtherMethodsViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

class OtherMethodsViewController: UIViewController {
    typealias Method = ScannerViewModel.OtherMethod
    
    lazy var mainView = OtherMethodsView()
    
    private var selectedMethod: ((Method) -> Void)?
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Signal<Method>
            .merge(
                mainView.manualButton.rx.tap.asSignal().map { _ in .manual },
                mainView.photoButton.rx.tap.asSignal().map { _ in .photo },
                mainView.filesButton.rx.tap.asSignal().map { _ in .file }
            )
            .emit(with: self, onNext: { base, method in
                base.dismiss(animated: true) { [weak base] in
                    base?.selectedMethod?(method)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension OtherMethodsViewController {
    static func make(selectedMethod: @escaping (Method) -> Void) -> OtherMethodsViewController {
        let vc = OtherMethodsViewController()
        vc.selectedMethod = selectedMethod
        return vc
    }
}
