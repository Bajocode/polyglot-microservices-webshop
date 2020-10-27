//
//  CatalogViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxCocoa
import RxSwift

struct CatalogViewModel {}

extension CatalogViewModel: ReactiveTransforming {
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    struct Output {
        let products: Observable<[Product]>
    }

    func transform(_ input: Input) -> Output {
        let products = input.viewWillAppear
            .flatMapLatest {
                return MicroserviceClient.execute(CatalogRequest.GetProducts())
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn([])
            }
            .share(replay: 1)

        return Output(products: products)
    }
}
