//
//  CreateOrEditFieldCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 04.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class CreateOrEditFieldCell: UICollectionViewListCell {
    lazy var fieldView = makeFieldView()
    
    private var fieldType: CreateOrEditSection.FieldType?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundConfiguration?.backgroundColor = .clear
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        if state.isSelected {
            fieldView.textFieldView.becomeFirstResponder()
        }
    }
}

// MARK: Public
extension CreateOrEditFieldCell {
    func setup(type: CreateOrEditSection.FieldType, text: String, editingAction: @escaping () -> Void, changeText: @escaping (String) -> Void) {
        fieldView.placeholder = type.placeholder
        fieldView.editAction = editingAction
        fieldView.didChange = changeText
        let value = type == .serviceCode ? text.separated() : text
        fieldView.text = value
        fieldView.isNeedFormatting = type == .serviceCode
    }
}

// MARK: Make constraints
private extension CreateOrEditFieldCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            fieldView.topAnchor.constraint(equalTo: contentView.topAnchor),
            fieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            fieldView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateOrEditFieldCell {
    func makeFieldView() -> CreateOrEditTextField {
        let view = CreateOrEditTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

extension CreateOrEditSection.FieldType {
    var placeholder: String {
        switch self {
        case .account:
            return "CreateOrEdit.Account".localized
        case .name:
            return "CreateOrEdit.Name".localized
        case .serviceCode:
            return "CreateOrEdit.Key".localized
        }
    }
}
