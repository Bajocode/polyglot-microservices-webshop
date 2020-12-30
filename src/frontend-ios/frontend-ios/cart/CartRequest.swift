//
//  CartRequest.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Moya

enum CartRequest {
    struct Get: CartRequesting {
        typealias ResponseType = Cart

        var method: Method {
            return .get
        }
        var path: String {
            return ""
        }
        var task: Task {
            return .requestPlain
        }
    }

    struct Put: CartRequesting {
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
        var task: Task {
            return .requestJSONEncodable(cart)
        }
    }
}

protocol CartRequesting: MicroserviceRequesting {}

extension CartRequesting {
    var port: Int {
        switch Config.env {
        case .dev:
            return 9002
        case .acc, .prod:
            return 443
        }
    }

    var servicePath: String {
        return "/cart"
    }
}
