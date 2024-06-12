//
//  AccountAction.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import Foundation
import UIKit

enum AccountAction: CaseIterable {
    case edit
    case delete
}

extension AccountAction {
    var name: String {
        switch self {
        case .edit:
            return "Accounts.EditAction".localized
        case .delete:
            return "Accounts.DeleteAction".localized
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .edit:
            return UIImage(named: "Accounts.Edit")
        case .delete:
            return UIImage(named: "Accounts.Delete")
        }
    }
}
