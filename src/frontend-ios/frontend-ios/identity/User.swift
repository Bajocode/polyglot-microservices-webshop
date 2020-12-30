//
//  User.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 17/11/2020.
//

import Foundation
import JWTDecode

internal struct User {
    var userid: String = ""
    let email: String
    var password: String = ""

    init(userid: String="", email: String, password: String="") {
        self.userid = userid
        self.email = email
        self.password = password
    }

    static func empty() -> User {
        return User(userid: "", email: "", password: "")
    }
}

extension User: Encodable {
    private enum EncodingKeys: String, CodingKey {
        case email, password
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
}

extension User: Decodable {
    private enum DecodingKeys: String, CodingKey {
        case userid, email
    }

    init(from decoder: Decoder) throws {
        let dto = try decoder.container(keyedBy: DecodingKeys.self)
        userid = try dto.decode(String.self, forKey: .userid)
        email = try dto.decode(String.self, forKey: .email)
    }
}
