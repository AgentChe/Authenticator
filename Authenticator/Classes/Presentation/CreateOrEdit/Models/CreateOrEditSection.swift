//
//  CreateOrEditSection.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 07.05.2024.
//

import Foundation

struct CreateOrEditSection: Hashable {
    let type: SectionType
    let items: [SectionItem]
    
    enum SectionType: Hashable {
        case field(example: String?)
        case backupCodes
    }
    
    enum FieldType {
        case account
        case name
        case serviceCode
    }
    
    enum SectionItem: Hashable {
        case field(FieldType, String)
        case backupCode(code: String)
    }
}
