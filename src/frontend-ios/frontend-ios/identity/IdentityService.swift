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
    internal var sharedUser: Observable<User> { return user.asObservable() }
    private var user = BehaviorRelay<User>(value: User.empty())

    internal func isLoggedIn() -> Bool {
        let token = tokenFromStore()
        guard
            !token.token.isEmpty,
            token.expiry > Int(Date().timeIntervalSince1970) else {
                return false
        }
        setUser(from: token)

        return true
    }

    internal func tokenFromStore() -> Token {
        let expiry = UserDefaults.standard.integer(forKey: Constants.UserDefaults.tokenExpiryKey)
        guard let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.tokenKey) else {
            return Token.empty()
        }

        return Token(token: token, expiry: expiry)
    }

    internal func storeToken(_ token: Token) {
        UserDefaults.standard.setValue(token.token, forKey: Constants.UserDefaults.tokenKey)
        UserDefaults.standard.setValue(token.expiry, forKey: Constants.UserDefaults.tokenExpiryKey)
    }

    internal func logOut() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.tokenKey)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.tokenExpiryKey)
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
