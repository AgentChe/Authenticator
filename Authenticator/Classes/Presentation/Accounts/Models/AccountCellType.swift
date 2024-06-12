//
//  AccountCellType.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import Foundation

enum AccountCellType {
    case empty
    case setupPassword
    case account(TOTPModel)
    case title(String)
    case search
}
