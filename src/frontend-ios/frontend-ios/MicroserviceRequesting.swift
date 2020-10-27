//
//  Microservice.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 26/10/2020.
//

import Moya

protocol MicroserviceRequesting: TargetType {
    associatedtype ResponseType: Decodable

    var scheme: String { get }
    var subdomain: String { get }
    var domain: String { get }
    var port: Int { get }
    var version: String { get }
    var servicePath: String { get }
}

extension MicroserviceRequesting {
    var scheme: String {
        switch Config.env {
        case .dev:
            return "http"
        case .acc, .prod:
            return "https"
        }
    }

    var subdomain: String {
        switch Config.env {
        case .dev:
            return ""
        case .acc:
            return "acc"
        case .prod:
            return "prod"
        }
    }

    var domain: String {
        switch Config.env {
        case .dev:
            return "0.0.0.0"
        case .acc, .prod:
            return "fabijanbajo.com"
        }
    }

    var version: String {
        return "v0"
    }

    var baseURL: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.port = port
        components.host = subdomain.isEmpty ? domain : subdomain + "." + domain
        components.path = servicePath

        guard let url = try? components.asURL() else {
            fatalError("baseUrl could not be created from components")
        }

        return url
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return [
            "content-type": "application/json"
        ]
    }
}
