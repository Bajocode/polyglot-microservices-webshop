//
//  CatalogViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxCocoa
import RxSwift

struct CatalogViewModel {
    let cartService: CartService

    init(_ cartService: CartService) {
        self.cartService = cartService
    }
}

extension CatalogViewModel: ReactiveTransforming {
    struct Input: CatalogViewModelInput {
        var viewWillAppear: Observable<Void>
    }
    struct Output: CatalogViewModelOutput {
        var products: Observable<[Product]>
    }

    func transform(_ input: Input) -> Output {
        let products = input.viewWillAppear
            .flatMapLatest { _ -> Single<[Product]> in
                return MicroserviceClient.execute(CatalogRequest.GetProducts())
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn([])
            }
            .share(replay: 1)

        return Output(products: products)
    }
}

protocol CatalogViewModelInput {
    var viewWillAppear: Observable<Void> { get }
}

protocol CatalogViewModelOutput {
    var products: Observable<[Product]> { get }
}
