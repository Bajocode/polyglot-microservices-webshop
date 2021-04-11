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
    internal var sharedToken: Token { return token.value }
    private var token = BehaviorRelay<Token>(value: Token.empty())
    internal var sharedUser: Observable<User> { return user.asObservable() }
    private var user = BehaviorRelay<User>(value: User.empty())

    internal func isLoggedIn() -> Bool {
        let token = self.token.value.token.isEmpty ? tokenFromStore() : self.token.value
        guard
            !token.token.isEmpty,
            token.expiry > Int(Date().timeIntervalSince1970) else {
                return false
        }

        return true
    }

    internal func storeToken(_ token: Token) {
        UserDefaults.standard.setValue(token.token, forKey: Constants.UserDefaults.tokenKey)
        UserDefaults.standard.setValue(token.expiry, forKey: Constants.UserDefaults.tokenExpiryKey)

        self.token.accept(token)
    }

    internal func logOut() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.tokenKey)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.tokenExpiryKey)
    }

    private func tokenFromStore() -> Token {
        let expiry = UserDefaults.standard.integer(forKey: Constants.UserDefaults.tokenExpiryKey)
        guard let tokenString = UserDefaults.standard.string(forKey: Constants.UserDefaults.tokenKey) else {
            return Token.empty()
        }

        let tokenFromStore = Token(token: tokenString, expiry: expiry)
        self.token.accept(tokenFromStore)

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
        user.accept(userFromToken)
    }
}
