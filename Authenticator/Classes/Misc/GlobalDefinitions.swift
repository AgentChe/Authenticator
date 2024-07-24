//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "MXsKvJS7wnnkBdh3"
    
    static let applicationTag = "AUTHENTIFICATOR"
    static let amplitudeApiKey = "d433d2c66723aeefd10c5b65f91c1fa3"
    
    static let termsOfUseUrl = URL(string: "https://camplain-apps.com/terms-of-use.html")!
    static let privacyPolicyUrl = URL(string: "https://camplain-apps.com/privacy-policy.html")!
    static let contactUsUrl = URL(string: "https://camplain-apps.com/contacts.html")!
    
    enum Paygate {
        static let yearly = "app.iphone.authentificator.yearly"
        static let weekly = "app.iphone.authentificator.weekly"
    }
}
