//
//  ScannerView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit

import AVFoundation

class ScannerView: UIView {
    lazy var scannerArea = makeScanArea()
    lazy var otherMethodsButton  = makeButton()
    lazy var infoButton = makeInfoButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Appearance.black
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        scannerArea.layoutIfNeeded()

        previewLayer?.frame = scannerArea.bounds
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer? {
        didSet {
            setupPreviewLayer(previewLayer, oldValue: oldValue)
        }
    }
}

// MARK: Make constraints
private extension ScannerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scannerArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 74.scale),
            scannerArea.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -74.scale),
            scannerArea.heightAnchor.constraint(equalTo: scannerArea.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            otherMethodsButton.topAnchor.constraint(equalTo: scannerArea.bottomAnchor, constant: 137.scale),
            otherMethodsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 113.scale),
            otherMethodsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -113.scale),
            otherMethodsButton.heightAnchor.constraint(equalToConstant: 40.scale),
            otherMethodsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoButton.heightAnchor.constraint(equalToConstant: 22.scale),
            infoButton.widthAnchor.constraint(equalTo: infoButton.heightAnchor),
            infoButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.scale),
            infoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ScannerView {
    func makeScanArea() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16.scale
        view.layer.borderWidth = 4.scale
        view.layer.borderColor = Appearance.primary.cgColor
        view.clipsToBounds = true
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.black)
            .textAlignment(.center)
        
        let attrsTitle = "Scan.OtherMethods".localized.attributed(with: attrs)
        let view = UIButton()
        view.setAttributedTitle(attrsTitle, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 16.scale
        addSubview(view)
        return view
    }
    
    func makeInfoButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Scan.Info"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func setupPreviewLayer(_ previewLayer: AVCaptureVideoPreviewLayer?, oldValue: AVCaptureVideoPreviewLayer?) {
        oldValue?.removeFromSuperlayer()

        if let layer = previewLayer {
            layer.frame = scannerArea.bounds
            layer.videoGravity = .resizeAspectFill

            scannerArea.layer.insertSublayer(layer, at: 0)
        }
    }
}
