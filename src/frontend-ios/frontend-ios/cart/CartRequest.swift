//
//  CartRequest.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Moya

protocol CartRequesting: MicroserviceRequesting {}

extension CartRequesting {
    var port: Int {
        switch Config.env {
        case .dev:
            return 8080
        case .acc, .prod:
            return 443
        }
    }

    var servicePath: String {
        return "/cart"
    }
}

enum CartRequest {
    struct Get: CartRequesting {
        typealias ResponseType = Cart
        private let token: Token

        init(_ token: Token) {
            self.token = token
        }

        var method: Method {
            return .get
        }
        var path: String {
            return ""
        }
        var headers: [String : String]? {
            return [
                "content-type": "application/json",
                "authorization": "Bearer \(token.token)"
            ]
        }
        var task: Task {
            return .requestPlain
        }
    }

    struct Put: CartRequesting {
        typealias ResponseType = Cart
        private let token: Token
        private let cart: Cart

        init(_ token: Token, cart: Cart) {
            self.token = token
            self.cart = cart
        }

        var method: Method {
            return .put
        }
        var path: String {
            return ""
        }
        var headers: [String : String]? {
            return [
                "content-type": "application/json",
                "authorization": "Bearer \(token.token)"
            ]
        }
        var task: Task {
            return .requestJSONEncodable(cart)
        }
    }
}
