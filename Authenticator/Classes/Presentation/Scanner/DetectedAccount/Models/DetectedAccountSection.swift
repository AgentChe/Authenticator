//
//  DetectedAccountSection.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 29.04.2024.
//

import Foundation

struct DetectedAccountSection: Hashable {
    let type: SectionType
    let items: [SectionItem]
    
    enum SectionType {
        case accountInfo
        case code
        case backupCodes
    }
    
    enum SectionItem: Hashable {
        case code(TOTPModel)
        case backupCode(String)
        case accountInfo(model: TokenModel, isSaved: Bool)
    }
}


