//
//  InstructionViewController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 11.06.2024.
//

import UIKit
import PDFKit

final class InstructionViewController: UIViewController {
    lazy var mainView = InstructionView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.pdfView.delegate = self
    }
}

extension InstructionViewController: PDFViewDelegate {
    func pdfViewWillClick(onLink sender: PDFView, with url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: Make
extension InstructionViewController {
    static func make(service: SetupServiceModel) -> InstructionViewController {
        let vc = InstructionViewController()
        if let document = Bundle.main.url(forResource: service.documentName, withExtension: "pdf") {
            vc.mainView.pdfView.document = PDFDocument(url: document)
        }
        return vc
    }
}


