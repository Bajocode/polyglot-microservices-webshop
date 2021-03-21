//
//  MediaRequest.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Moya

protocol MediaRequesting: MicroserviceRequesting {}
extension MediaRequesting {
    var port: Int {
        switch Config.env {
        case .dev:
            return 8080
        case .acc, .prod:
            return 443
        }
    }

    var servicePath: String {
        return "/media"
    }
}

enum MediaRequest {
    struct GetImageData: MediaRequesting {
        typealias ResponseType = Data
        private let imagePath: String
        private let token: Token

        init(_ token: Token, imagePath: String) {
            self.token = token
            self.imagePath = imagePath
        }

        var method: Method {
            return .get
        }
        var path: String {
            return "/\(imagePath)"
        }
        var headers: [String : String]? {
            return [
                "accept": "application/octet-stream",
                "authorization": "Bearer \(token.token)"
            ]
        }
        var task: Task {
            return .requestPlain
        }
    }
}
