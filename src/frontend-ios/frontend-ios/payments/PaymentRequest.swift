//
//  PaymentRequest.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Moya

struct Payment: Decodable {}

enum PaymentRequest {
    struct Get: PaymentRequesting {
        typealias ResponseType = Payment

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
}

protocol PaymentRequesting: MicroserviceRequesting {}

extension PaymentRequesting {
    var port: Int {
        switch Config.env {
        case .dev:
            return 8080
        case .acc, .prod:
            return 443
        }
    }

    var servicePath: String {
        return "/charge"
    }
}
