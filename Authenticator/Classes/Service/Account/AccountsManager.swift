//
//  AccountsManager.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 15.05.2024.
//

import Foundation
import FirebaseFirestoreInternal
import RxSwift
import RxCocoa
import OtterScaleiOS

final class AccountsManager {
    private let db = Firestore.firestore()
    
    init() {
        
        db.collection(OtterScale.shared.getInternalID()).addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
            
        })
    }
    
    func reSave() -> Completable {
        Completable.create {  observer in
            Task {
                do {
                    try await self.resaveTokens()
                    AccountsMediator.share.notify()
                    observer(.completed)
                } catch {
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func save(token: TokenModel) -> Completable {
        Completable.create { [weak self] observer in
            Task { [weak self] in
                do {
                    try await self?.saveToken(token)
                    AccountsMediator.share.notify()
                    observer(.completed)
                } catch {
                    observer(.error(error))
                }
                
            }
            return Disposables.create()
        }
    }
    
    func delete(token: TokenModel) -> Completable {
        Completable.create { [weak self] observer in
            Task { [weak self] in
                do {
                    try await self?.deleteToken(token)
                    AccountsMediator.share.notify()
                    observer(.completed)
                } catch {
                    observer(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func makeAccounts() -> Observable<[TokenModel]> {
        Observable.create { [weak self] observer in
            Task { [weak self] in
                do {
                    let elements = try await self?.load()
                    observer.onNext(elements ?? [])
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    private static let dataKey = "data"
}

private extension AccountsManager {
    func saveToken(_ token: TokenModel) async throws {
        let data = try JSONEncoder().encode(token)
        let encryptContent = try CryptoManager.shared.encrypt(content: data)
        let id = OtterScale.shared.getInternalID()
        
        try await self.db.collection(id)
            .document(token.id)
            .setData([Self.dataKey: encryptContent])
    }
    
    func deleteToken(_ token: TokenModel) async throws {
        let id = OtterScale.shared.getInternalID()
        
        try await db.collection(id)
            .document(token.id)
            .delete()
    }
    
    func load() async throws -> [TokenModel] {
        let id = OtterScale.shared.getInternalID()
        
        let items = try await self.db.collection(id).getDocuments(source: .cache)
        
        return items.documents
            .compactMap { document -> TokenModel? in
                guard let data = document.data()[Self.dataKey] as? Data else { return nil }
                guard let decrypt = try? CryptoManager.shared.decrypt(content: data)  else { return nil }
                
                return try? JSONDecoder().decode(TokenModel.self, from: decrypt)
            }
    }
    
    func resaveTokens() async throws {
        let anonymousID = OtterScale.shared.getAnonymousID()
        let internalID = OtterScale.shared.getInternalID()
        
        let collection = try await db.collection(anonymousID).getDocuments()
        let new = db.collection(internalID)
        let batch = db.batch()
        
        collection.documents.forEach { snapshot in
            let data = snapshot.data()
            guard !data.isEmpty else { return }
            let docRef = new.document(snapshot.documentID)
            batch.setData(data, forDocument: docRef)
            batch.deleteDocument(snapshot.reference)
        }
        
        try await batch.commit()
    }
}
