//
//  AuthRequest.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 17/11/2020.
//

import Moya

enum AuthRequest {
    struct Register: AuthRequesting {
        typealias ResponseType = Token
        private let user: User

        init(user: User) {
            self.user = user
        }

        var path: String {
            return "/register"
        }
        var method: Method {
            return .post
        }
        var task: Task {
            return .requestJSONEncodable(user)
        }
    }

    struct Login: AuthRequesting {
        typealias ResponseType = Token
        private let user: User

        init(user: User) {
            self.user = user
        }

        var path: String {
            return "/login"
        }
        var method: Method {
            return .post
        }
        var task: Task {
            return .requestJSONEncodable(user)
        }
    }
}

protocol AuthRequesting: MicroserviceRequesting {}

extension AuthRequesting {
    var port: Int {
        switch Config.env {
        case .dev:
            return 8080
        case .acc, .prod:
            return 443
        }
    }

    var servicePath: String {
        return "/auth"
    }
}
