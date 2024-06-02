//
//  TokenModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import Foundation

struct TokenModel: Hashable {
    let id: String
    var issuer: String
    var userName: String
    var secret: Data
    let algorithm: Algorithm
    let digits: Int
    let period: Int
    var backupCodes: [String] = []
    
    enum Algorithm: String, Codable {
        case sha1 = "SHA1"
        case sha256 = "SHA256"
        case sha512 = "SHA512"
    }
    
    init(id: String = UUID().uuidString, issuer: String = "", userName: String = "", secret: Data, algorithm: Algorithm = .sha256, digits: Int = 6, period: Int = 30, backupCodes: [String] = []) {
        self.id = id
        self.issuer = issuer
        self.userName = userName
        self.secret = secret
        self.algorithm = algorithm
        self.digits = digits
        self.period = period
        self.backupCodes = backupCodes
    }
}

extension TokenModel {
    
    init(secretData: Data) {
        self.init(secret: secretData)
    }
    
    init?(secret: String) {
        guard let secretData = Data(base32Encoded: secret) else { return nil }
        self.init(secretData: secretData)
        
    }
    
    init?(from url: URL) {
        guard url.host?.lowercased() == "totp", let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
            return nil
        }
        
        guard let secret = queryItems.first(where: { $0.name == "secret"})?.value, let secretData = Data(base32Encoded: secret) else {
            return nil
        }
        self.id = UUID().uuidString
        self.secret = secretData
        self.issuer = queryItems.first(where: { $0.name == "issuer"})?.value ?? ""
        let splitedUserName = url.path.dropFirst().split(separator: ":")
        self.userName = splitedUserName.last.map { String($0) } ?? ""
        self.algorithm = queryItems
            .first(where: { $0.name == "algorithm" })?.value
            .flatMap { TokenModel.Algorithm(rawValue: $0) } ?? .sha256
        self.period = queryItems.first(where: { $0.name == "period"})?.value.flatMap { Int($0) } ?? 30
        self.digits = queryItems.first(where: { $0.name == "digits"})?.value.flatMap { Int($0) } ?? 6
    }
}

extension TokenModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case issuer
        case userName
        case secret
        case algorithm
        case digits
        case period
        case backupCodes
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        issuer = try values.decode(String.self, forKey: .issuer)
        userName = try values.decode(String.self, forKey: .userName)
        secret = try values.decode(Data.self, forKey: .secret)
        algorithm = try values.decode(TokenModel.Algorithm.self, forKey: .algorithm)
        digits = try values.decode(Int.self, forKey: .digits)
        period = try values.decode(Int.self, forKey: .period)
        backupCodes = try values.decode([String].self, forKey: .backupCodes)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(issuer, forKey: .issuer)
        try container.encode(userName, forKey: .userName)
        try container.encode(secret, forKey: .secret)
        try container.encode(algorithm, forKey: .algorithm)
        try container.encode(digits, forKey: .digits)
        try container.encode(period, forKey: .period)
        try container.encode(backupCodes, forKey: .backupCodes)
    }
}
