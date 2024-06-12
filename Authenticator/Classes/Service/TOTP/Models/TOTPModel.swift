//
//  TOTPModel.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import Foundation
import RxSwift

struct TOTPModel {
    let timer: Observable<Int>
    let model: TokenModel
    let code: Observable<String>
}

extension TOTPModel: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.model == rhs.model
    }
}

extension TOTPModel: Hashable {
    func hash(into hasher: inout Hasher) {
        model.hash(into: &hasher)
    }
}
