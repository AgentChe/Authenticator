//
//  CreateOrEditView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 04.05.2024.
//

import UIKit

class CreateOrEditView: UIView {
    
    lazy var collectionView = makeCollectionView()
    lazy var saveButton = makeSaveButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Appearance.black
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension CreateOrEditView {
    func makeConstraints() {
        let collectionBottomConstraint = collectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16.scale)
        collectionBottomConstraint.priority = .fittingSizeLevel
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            collectionBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60.scale),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateOrEditView {
    func makeCollectionView() -> CreateOrEditCollectionView {
        let view = CreateOrEditCollectionView(frame: .zero, collectionViewLayout: .init())
        view.keyboardDismissMode = .interactive
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.black)
            .textAlignment(.center)
        let attrsTitle = "Save".localized.attributed(with: attrs)
        
        let view = UIButton()
        view.setAttributedTitle(attrsTitle, for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
