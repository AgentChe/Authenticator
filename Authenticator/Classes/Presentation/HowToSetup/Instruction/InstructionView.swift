//
//  InstructionView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 11.06.2024.
//
import UIKit
import PDFKit

final class InstructionView: UIView {
    lazy var pdfView = makePDFView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension InstructionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pdfView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension InstructionView {
    func makePDFView() -> PDFView {
        let view = PDFView()
        view.displayDirection = .vertical
        view.backgroundColor = Appearance.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
