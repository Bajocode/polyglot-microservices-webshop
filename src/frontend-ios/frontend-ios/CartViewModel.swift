//
//  CartViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxCocoa
import RxSwift

struct CartViewModel {}

extension CartViewModel: ReactiveTransforming {
    struct Input: CartViewModelInput {
        var viewWillAppear: Observable<Void>
    }
    struct Output: CartViewModelOutput {
        var cart: Observable<Cart>
    }

    func transform(_ input: Input) -> Output {
        let cart = input.viewWillAppear
            .flatMapLatest {
                return MicroserviceClient.execute(CartRequest.Get())
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(Cart.empty())
            }
            .share(replay: 1)

        return Output(cart: cart)
    }
}

protocol CartViewModelInput {
    var viewWillAppear: Observable<Void> { get }
}

protocol CartViewModelOutput {
    var cart: Observable<Cart> { get }
}
