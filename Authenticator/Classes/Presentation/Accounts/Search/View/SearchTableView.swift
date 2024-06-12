//
//  SearchTableView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 19.05.2024.
//

import UIKit
import RxCocoa

class SearchTableView: UITableView {

    lazy var didTapMore = PublishRelay<TOTPModel>()
    var elements: [TOTPModel] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchTableView {
    func setup(elements: [TOTPModel]) {
        self.elements = elements
        reloadData()
    }
}

extension SearchTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = elements[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountCell.self), for: indexPath) as! AccountCell
        cell.setup(model: model) { [weak self] in
            self?.didTapMore.accept(model)
        }
        
        return cell
    }
}

private extension SearchTableView {
    func initialize() {
        dataSource = self
        keyboardDismissMode = .interactive
        separatorStyle = .none
        register(AccountCell.self, forCellReuseIdentifier: String(describing: AccountCell.self))
    }
}
