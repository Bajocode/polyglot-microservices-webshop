//
//  MicroserviceClient.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Moya
import RxSwift

// krakend.io gateway automatically wraps array responses with root "collection" key
struct KrakenWrapper<T: Decodable>: Decodable {
    let collection: T
}

struct MicroserviceClient {
    private static let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin()])

    static func execute<T: MicroserviceRequesting>(_ request: T, wrapped: Bool=false) -> Single<T.ResponseType> {
        return provider
            .rx
            .request(MultiTarget(request))
            .map {
                guard let unwrapped = try? JSONDecoder().decode(KrakenWrapper<T.ResponseType>.self, from: $0.data) else {
                    return try JSONDecoder().decode(T.ResponseType.self, from: $0.data)
                }
                return unwrapped.collection
            }
    }
}
