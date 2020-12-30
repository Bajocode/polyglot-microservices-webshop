//
//  CatalogService.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Moya

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
    var servicePath: String { return "/catalog" }
}

internal enum CatalogRequest {
    internal struct GetCategories: CatalogRequesting {
        typealias ResponseType = [Category]
        private let params: [String: Any]?

        init(_ params: [String: Any]?=nil) {
            self.params = params
        }

        var path: String {
            return "/categories"
        }
        var method: Method {
            return .get
        }
        var task: Task {
            guard let params = self.params else {
                return .requestPlain
            }
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.queryString)
        }
    }

    internal struct GetProducts: CatalogRequesting {
        typealias ResponseType = [Product]
        private let params: [String: Any]?

        init(_ params: [String: Any]?=nil) {
            self.params = params
        }

        var path: String {
            return "/products"
        }
        var method: Method {
            return .get
        }
        var task: Task {
            guard let params = self.params else {
                return .requestPlain
            }
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.queryString)
        }
    }
}
