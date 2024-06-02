//
//  BackupCodeBackgroundView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import UIKit

class BackupCodeBackgroundView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.3)
        layer.cornerRadius = 16.scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
