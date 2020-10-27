//
//  MicroserviceClient.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Moya
import RxSwift

struct MicroserviceClient {
    private static let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin()])

    static func execute<T: MicroserviceRequesting>(_ request: T) -> Single<T.ResponseType> {
        return provider
            .rx
            .request(MultiTarget(request))
            .map(T.ResponseType.self)
    }
}
