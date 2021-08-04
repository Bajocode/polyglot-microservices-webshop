//
//  OrderRequest.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Moya

protocol OrderRequesting: MicroserviceRequesting {}
extension OrderRequesting {
    var port: Int {
        switch Config.env {
        case .dev:
            return 8080
        case .acc, .prod:
            return 443
        }
    }

    var servicePath: String {
        return "/orders"
    }
}

enum OrderRequest {
    internal struct Get: OrderRequesting {
        typealias ResponseType = [Order]

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

    internal struct GetOne: OrderRequesting {
        typealias ResponseType = Order
        private let order: Order

        init(order: Order) {
            self.order = order
        }

        var method: Method {
            return .get
        }
        var path: String {
            return "/\(order.orderid)"
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

    internal struct Post: OrderRequesting {
        typealias ResponseType = Order
        private let order: Order

        init(order: Order) {
            self.order = order
        }

        var method: Method {
            return .post
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
            return .requestJSONEncodable(order)
        }
    }
}
