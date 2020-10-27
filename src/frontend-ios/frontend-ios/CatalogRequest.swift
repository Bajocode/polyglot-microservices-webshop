//
//  CatalogService.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Moya

enum CatalogRequest {
    struct GetProducts: CatalogRequesting {
        typealias ResponseType = [Product]

        var path: String {
            return "/products"
        }

        var method: Method {
            return .get
        }

        var task: Task {
            return .requestPlain
        }
    }
}

protocol CatalogRequesting: MicroserviceRequesting {}

extension CatalogRequesting {
    var port: Int {
        switch Config.env {
        case .dev:
            return 9001
        case .acc, .prod:
            return 443
        }
    }

    var servicePath: String {
        return "/catalog"
    }
}
