//
//  MenuSection.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 10.05.2024.
//

import Foundation
import UIKit

struct MenuSection: Hashable {
    let section: SectionType
    let items: [SectionItem]
    
    enum SectionType: Hashable {
        case account
        case about
        case setup
    }
    
    enum SectionItem: Hashable {
        case action(ActionType)
        case actionWithIcon(ActionWithIcon)
        case biometry(BiometryType, Bool)
        case setup
    }
    
    enum ActionType {
        case privacyPolicy
        case termsOfUse
        case contactUs
    }
        
    enum ActionWithIcon {
        case setupPassword
        case changePassword
    }
}

extension MenuSection.ActionType {
    var title: String {
        switch self {
        case .privacyPolicy:
            return "Menu.PrivacyPolicy".localized
        case .termsOfUse:
            return "Menu.TermsOfUse".localized
        case .contactUs:
            return "Menu.ContactUs".localized
        }
    }
}

extension MenuSection.ActionWithIcon {
    var title: String {
        switch self {
        case .setupPassword:
            return "Menu.SetPassword".localized
        case .changePassword:
            return "Menu.ChangePassword".localized
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .setupPassword, .changePassword:
            return UIImage(named: "Menu.Password")
        }
    }
}
