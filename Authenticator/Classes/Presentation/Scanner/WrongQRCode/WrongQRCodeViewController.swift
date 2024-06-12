//
//  WrongQRCodeViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 29.04.2024.
//

import UIKit

class WrongQRCodeViewController: UIViewController {
    
    lazy var mainVew = WrongQRCodeView()
    
    private var didClose: (() -> Void)?
    
    override func loadView() {
        view = mainVew
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainVew.primaryButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    deinit {
        didClose?()
    }
}

extension WrongQRCodeViewController {
    static func make(didClose: @escaping () -> Void) -> WrongQRCodeViewController {
        let vc = WrongQRCodeViewController()
        vc.didClose = didClose
        return vc
    }
}

private extension WrongQRCodeViewController {
    @objc func buttonAction() {
        didClose?()
        dismiss(animated: true)
    }
}
