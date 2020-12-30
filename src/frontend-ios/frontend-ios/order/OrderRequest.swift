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
            return 9003
        case .acc, .prod:
            return 443
        }
    }

    var servicePath: String {
        return "/orders"
    }
}

enum OrderRequest {
    struct Get: OrderRequesting {
        typealias ResponseType = [Order]

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

    struct GetOne: OrderRequesting {
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
        var task: Task {
            return .requestPlain
        }
    }

    struct Post: OrderRequesting {
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
        var task: Task {
            return .requestJSONEncodable(order)
        }
    }
}
