//
//  IdentityService.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 18/11/2020.
//

import RxSwift
import RxCocoa
import JWTDecode

internal class IdentityService {
    internal static let shared = IdentityService()
    internal var token: Token = Token.empty()
    internal var user: User = User.empty()

    internal func isLoggedIn() -> Bool {
        let token = self.token.token.isEmpty ? tokenFromStore() : self.token
        guard
            !token.token.isEmpty,
            token.expiry > Double(Date().timeIntervalSince1970) else {
                return false
        }

        return true
    }

    internal func storeToken(_ token: Token) {
        UserDefaults.standard.setValue(token.token, forKey: Constants.UserDefaults.tokenKey)
        UserDefaults.standard.setValue(token.expiry, forKey: Constants.UserDefaults.tokenExpiryKey)

        self.token = token
    }

    internal func logOut() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.tokenKey)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.tokenExpiryKey)
    }

    private func tokenFromStore() -> Token {
        let expiry = UserDefaults.standard.double(forKey: Constants.UserDefaults.tokenExpiryKey)
        guard let tokenString = UserDefaults.standard.string(forKey: Constants.UserDefaults.tokenKey) else {
            return Token.empty()
        }

        let tokenFromStore = Token(token: tokenString, expiry: expiry)
        self.token = tokenFromStore

        return tokenFromStore
    }

    private func setUser(from token: Token) {
        guard
            let body = try? decode(jwt: token.token).body,
            let claims = body["user"],
            let json = try? JSONSerialization.data(withJSONObject: claims),
            let userFromToken = try? JSONDecoder().decode(User.self, from: json) else {
            return
        }
        user = userFromToken
    }
}
