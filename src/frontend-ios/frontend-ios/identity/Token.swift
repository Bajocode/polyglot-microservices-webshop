//
//  Token.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 17/11/2020.
//

import Foundation

internal struct Token: Decodable {
    let token: String
    let expiry: Double

    init(token: String, expiry: Double) {
        self.token = token
        self.expiry = expiry
    }

    static func empty() -> Token {
        return Token(token: "", expiry: 0)
    }
}
