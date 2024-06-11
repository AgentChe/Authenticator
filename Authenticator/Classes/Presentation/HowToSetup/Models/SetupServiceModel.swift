//
//  SetupServiceModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 11.06.2024.
//

import Foundation
import UIKit

enum SetupServiceModel: String, CaseIterable {
    case `default`
    case tiktok
    case notion
    case microsoft
    case binance
    case dropbox
    case x
    case instagram
    case facebook
    case reddit
}

extension SetupServiceModel {
    var name: String {
        switch self {
        case .default:
            return "HowTo.Default".localized
        case .tiktok:
            return "TikTok"
        case .notion:
            return "Notion"
        case .microsoft:
            return "Microsoft"
        case .binance:
            return "Binance"
        case .dropbox:
            return "Dropbox"
        case .x:
            return "X"
        case .instagram:
            return "Instagram"
        case .facebook:
            return "Facebook"
        case .reddit:
            return "Reddit"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .default:
            return UIImage(named: "Services.Default")
        case .tiktok:
            return UIImage(named: "Services.TikTok")
        case .notion:
            return UIImage(named: "Services.Notion")
        case .microsoft:
            return UIImage(named: "Services.Microsoft")
        case .binance:
            return UIImage(named: "Services.Binance")
        case .dropbox:
            return UIImage(named: "Services.Dropbox")
        case .x:
            return UIImage(named: "Services.X")
        case .instagram:
            return UIImage(named: "Services.Instagram")
        case .facebook:
            return UIImage(named: "Services.Facebook")
        case .reddit:
            return UIImage(named: "Services.Reddit")
        }
    }
    
    var documentName: String {
        switch self {
        case .default:
            return "Instruction.Default"
        case .tiktok:
            return "Instruction.TikTok"
        case .notion:
            return "Instruction.Notion"
        case .microsoft:
            return "Instruction.Microsoft"
        case .binance:
            return "Instruction.Binance"
        case .dropbox:
            return "Instruction.Dropbox"
        case .x:
            return "Instruction.X"
        case .instagram:
            return "Instruction.Instagram"
        case .facebook:
            return "Instruction.Facebook"
        case .reddit:
            return "Instruction.Reddit"
        }
    }
}
