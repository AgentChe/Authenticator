//
//  SearchCell.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import UIKit

final class SearchCell: UITableViewCell {
    
    private lazy var searchField = makeSearchField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: Private
private extension SearchCell {
    func initialize() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SearchCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            searchField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            searchField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            searchField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchCell {
    func makeSearchField() -> SearchTextField {
        let view = SearchTextField()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
