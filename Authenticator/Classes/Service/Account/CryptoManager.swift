//
//  CryptoManager.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 23.05.2024.
//

import Foundation
import CryptoKit
import OtterScaleiOS

final class CryptoManager {
    static let shared = CryptoManager()
    
    private let serviceValue = "service.symmetryc.key"
    private let account = Bundle.main.bundleIdentifier ?? "authenticator.account.crypto.manager"
    
    private init() { }
    
    func encrypt(content: Data) throws -> Data {
        let key = try readKey()
        return try ChaChaPoly.seal(content, using: key).combined
    }
    
    func decrypt(content: Data) throws -> Data {
        let key = try readKey()
        let box = try ChaChaPoly.SealedBox(combined: content)
        return try ChaChaPoly.open(box, using: key)
    }
    
    func updateKeySettings() throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
            kSecAttrAccount: account,
            kSecAttrService: serviceValue,
            kSecAttrSynchronizable: true,
        ] as [String: Any]
        
        let hasSubscription = SessionManager().hasActiveSubscriptions()
        
        let attrs = [
            kSecAttrSynchronizable: hasSubscription
        ] as [String: Any]
        
        switch SecItemUpdate(query as CFDictionary, attrs as CFDictionary) {
        case errSecSuccess:
            return
        case errSecItemNotFound:
            try storeKey()
        case let status:
            throw KeyStoreError("Keychain update failed: \(status.message)")
        }
    }
}

private extension CryptoManager {
    func storeKey() throws {
        let key = SymmetricKey(size: .bits256)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
            kSecAttrAccount: account,
            kSecAttrService: serviceValue,
            kSecValueData: key.rawRepresentation,
            kSecAttrSynchronizable: true
        ] as [String: Any]
        
        switch SecItemAdd(query as CFDictionary, nil) {
        case errSecSuccess, errSecDuplicateItem:
            return
        case let status:
            throw KeyStoreError("Keychain store failed: \(status.message)")
        }
    }
    
    func readKey() throws -> SymmetricKey {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
            kSecAttrAccount: account,
            kSecAttrService: serviceValue,
            kSecAttrSynchronizable: true,
            kSecReturnData: true
        ] as [String: Any]
        
        var item: CFTypeRef?
        
        switch SecItemCopyMatching(query as CFDictionary, &item) {
        case errSecSuccess:
            guard let data = item as? Data else { throw KeyStoreError("Keychain read failed: incorrect returned data") }
            return try SymmetricKey(rawRepresentation: data)
        case errSecItemNotFound:
            try storeKey()
            return try readKey()
        case let status:
            throw KeyStoreError("Keychain read failed: \(status.message)")
        }
    }
}

extension SymmetricKey {
    init<D>(rawRepresentation data: D) throws where D: ContiguousBytes {
        self.init(data: data)
    }
    
    var rawRepresentation: Data {
        return dataRepresentation
    }
}

extension ContiguousBytes {
    var dataRepresentation: Data {
        return self.withUnsafeBytes { bytes in
            let cfdata = CFDataCreateWithBytesNoCopy(nil, bytes.baseAddress?.assumingMemoryBound(to: UInt8.self), bytes.count, kCFAllocatorNull)
            return ((cfdata as NSData?) as Data?) ?? Data()
        }
    }
}

struct KeyStoreError: Error, CustomStringConvertible {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var description: String {
        return message
    }
}

extension OSStatus {
    var message: String {
        return (SecCopyErrorMessageString(self, nil) as String?) ?? String(self)
    }
}
