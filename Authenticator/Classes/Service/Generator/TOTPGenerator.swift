//
//  TOTPGenerator.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import Foundation
import CryptoKit

struct TOTPGenerator {
    static func getCode(for model: TokenModel, with date: Date) -> String {
        let timeCounter = UInt64(date.timeIntervalSince1970 / TimeInterval(model.period))
        var counter = timeCounter.bigEndian
        let timerData = Data(bytes: &counter, count: MemoryLayout<UInt64>.size)
        
        let hmacData: Data
        switch model.algorithm {
        case .sha1:
            hmacData = Data(HMAC<Insecure.SHA1>.authenticationCode(for: timerData, using: SymmetricKey(data: model.secret)))
        case .sha256:
            hmacData = Data(HMAC<SHA256>.authenticationCode(for: timerData, using: SymmetricKey(data: model.secret)))
        case .sha512:
            hmacData = Data(HMAC<SHA512>.authenticationCode(for: timerData, using: SymmetricKey(data: model.secret)))
        }
        
        let offset = Int((hmacData.last ?? 0x00) & 0x0f)
        
        let truncatedHMAC = Array(hmacData[offset...offset + 3])
        
        let data = Data(truncatedHMAC)
        
        var number = UInt32(strtoul(data.bytes.toHexString(), nil, 16))
        number &= 0x7fffffff
        let value = pow(10, Float(model.digits))
        guard Int(value) <= UInt32.max else { return "" }
        
        number = number % UInt32(value)
        
        let strNum = String(number)
        
        if strNum.count == model.digits { return strNum }
    
        let prefixedZeros = String(repeatElement("0", count: (model.digits - strNum.count)))
        return (prefixedZeros + strNum)
    }
}
