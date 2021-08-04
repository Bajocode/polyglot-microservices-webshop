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
    internal struct GetImageData: MediaRequesting {
        typealias ResponseType = Data
        private let imagePath: String

        init(imagePath: String) {
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
                "authorization": "Bearer \(IdentityService.shared.token.token)"
            ]
        }
        var task: Task {
            return .requestPlain
        }
        var url: URL {
            return URL(string: baseURL.absoluteString + path)!
        }
    }
}
