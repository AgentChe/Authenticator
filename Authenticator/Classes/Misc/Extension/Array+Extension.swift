//
//  Array+Extension.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.04.2024.
//

import Foundation

extension Array where Element == UInt8 {
    func toHexString() -> String {
        `lazy`.reduce(into: "") {
          var s = String($1, radix: 16)
          if s.count == 1 {
            s = "0" + s
          }
          $0 += s
        }
    }
}
