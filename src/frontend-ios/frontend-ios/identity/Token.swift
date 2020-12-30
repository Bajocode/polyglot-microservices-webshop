//
//  Token.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 17/11/2020.
//

import Foundation

internal struct Token: Decodable {
    let token: String
    let expiry: Int

    init(token: String, expiry: Int) {
        self.token = token
        self.expiry = expiry
    }

    static func empty() -> Token {
        return Token(token: "", expiry: 0)
    }
}
