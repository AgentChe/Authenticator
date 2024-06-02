//
//  TOTPService.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import Foundation
import RxSwift

final class TOTPService {
    func makeTokens(for models: [TokenModel]) -> [TOTPModel] {
        var timers: [Int: Observable<Int>] = [:]
        return models
            .map { token in
                let timer = timers[token.period] ?? timer(totpPeriod: token.period).share(replay: 1)
                timers[token.period] = timer
                
                let code = timer
                    .scan(nil) { code, time -> String? in
                        guard let code = code else { return TOTPGenerator.getCode(for: token, with: .init()) }
                        return time == token.period ? TOTPGenerator.getCode(for: token, with: .init()) : code
                    }
                    .compactMap { $0?.separated(stride: 3) }
                    .distinctUntilChanged()
                    .share(replay: 1)
                
                return TOTPModel(timer: timer, model: token, code: code)
            }
    }
    
    func makeToken(for model: TokenModel) -> TOTPModel {
        let timer = timer(totpPeriod: model.period)
            .share(replay: 1)
        
        let code = timer
            .scan(nil) { code, time -> String? in
                guard let code = code else { return TOTPGenerator.getCode(for: model, with: .init()) }
                return time == model.period ? TOTPGenerator.getCode(for: model, with: .init()) : code
            }
            .compactMap { $0?.separated(stride: 3) }
            .distinctUntilChanged()
            .share(replay: 1)
        
        return TOTPModel(timer: timer, model: model, code: code)
    }
}

private extension TOTPService {
    func timer(totpPeriod: Int) -> Observable<Int> {
        return Observable.deferred {
            return Observable<Int>
                .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
                .map { _ -> Int in
                    let currentTime = Int(round(CFAbsoluteTimeGetCurrent().truncatingRemainder(dividingBy: Double(totpPeriod))))
                    return totpPeriod - currentTime
                    
                }
        }
    }
}
