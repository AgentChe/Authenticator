//
//  HowToSetupTableView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 11.06.2024.
//

import UIKit
import RxCocoa

class HowToSetupTableView: UITableView {
    
    lazy var selectedService = PublishRelay<SetupServiceModel>()
    
    var elements: [SetupServiceModel] = []
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HowToSetupTableView {
    func setup(elements: [SetupServiceModel]) {
        self.elements = elements
        reloadData()
    }
}

extension HowToSetupTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SetupServiceViewCell.self), for: indexPath) as! SetupServiceViewCell
        cell.setup(service: elements[indexPath.row])
        return cell
    }
}


extension HowToSetupTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedService.accept(elements[indexPath.row])
    }
}

private extension HowToSetupTableView {
    func initialize() {
        dataSource = self
        delegate = self
        separatorStyle = .none
        register(SetupServiceViewCell.self, forCellReuseIdentifier: String(describing: SetupServiceViewCell.self))
    }
}
