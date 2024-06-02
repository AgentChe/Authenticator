//
//  LocalAuthenticationManager.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 10.05.2024.
//

import Foundation
import LocalAuthentication
import RxSwift

protocol LocalAuthenticationManagerProtocol {
    func savePassword(_ password: String) -> Bool
    func updatePassword(_ password: String) -> Bool
    func checkPassword(_ password: String) -> Bool
    func availableBiometryType() -> BiometryType?
}

final class LocalAuthenticationManager: LocalAuthenticationManagerProtocol {
    func deletePassword() {
        SecItemDelete(query as CFDictionary)
    }
    
    func savePassword(_ password: String) -> Bool {
        deletePassword()
        guard let passwordData = password.data(using: .utf8) else { return false }
        
        var queryRequest = query
        queryRequest[kSecValueData as String] = passwordData
        
        let status = SecItemAdd(queryRequest as CFDictionary, nil)
        
        if status == errSecSuccess {
            LocalAuthenticationMediator.shared.notify(password: true)
        }
        
        return status == errSecSuccess
    }
    
    func updatePassword(_ password: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else { return false }
        
        let updateQuery = [kSecValueData as String: passwordData]
        
        let status = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
        
        return status == errSecSuccess
    }
    
    func checkPassword(_ password: String) -> Bool {
        guard let savedPassword = getPassword() else { return false }
        return password == savedPassword
    }
    
    func availableBiometryType() -> BiometryType? {
        let context = LAContext()
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else { return nil }
        
        switch context.biometryType {
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        default:
            return nil
        }
    }
    
    func setBiometricAuthentication(isEnabled: Bool) -> Observable<Bool> {
        Observable.create { observer in
            let context = LAContext()
            let reason = "Authenticate to unlock your app."
            context.localizedFallbackTitle = ""
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    UserDefaults.standard.set(isEnabled, forKey: Self.availableBiometricAuthenticationKey)
                    LocalAuthenticationMediator.shared.notify()
                }
                
                observer.onNext(success)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
        
    }
    
    func biometricAuthenticationResult() -> Observable<Bool> {
        
        Observable.create { observer in
            let context = LAContext()
            let reason = "Authenticate to unlock your app."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                observer.onNext(success)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    var isAvailableBiometricAuthentication: Bool {
        UserDefaults.standard.bool(forKey: Self.availableBiometricAuthenticationKey) 
    }
    
    var isAvailablePasswordAuthentication: Bool {
        getPassword() != nil
    }
    
    private static let availableBiometricAuthenticationKey = "kAvailableBiometricAuthenticationKey"
}

private extension LocalAuthenticationManager {
    var query: [String: Any] {
        var query: [String: Any] = [:]
        query[kSecClass as String] = kSecClassKey
        query[kSecAttrApplicationTag as String] = "kPasscodeAuthenticationKey".data(using: .utf8)
        return query
    }
    
    func getPassword() -> String? {
        var queryRequest = query
        queryRequest[kSecReturnData as String] = true
        
        var item: CFTypeRef?
        
        let status = SecItemCopyMatching(queryRequest as CFDictionary, &item)
        
        guard status == errSecSuccess else { return nil }
        
        guard let data = item as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
}
