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
    internal struct Get: CartRequesting {
        typealias ResponseType = Cart

        var method: Method {
            return .get
        }
        var path: String {
            return ""
        }
        var headers: [String : String]? {
            return [
                "content-type": "application/json",
                "authorization": "Bearer \(IdentityService.shared.token.token)"
            ]
        }
        var task: Task {
            return .requestPlain
        }
    }

    internal struct Put: CartRequesting {
        typealias ResponseType = Cart
        private let cart: Cart

        init(cart: Cart) {
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
                "authorization": "Bearer \(IdentityService.shared.token.token)"
            ]
        }
        var task: Task {
            return .requestJSONEncodable(cart)
        }
    }
}
