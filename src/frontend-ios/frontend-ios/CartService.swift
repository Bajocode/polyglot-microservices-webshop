//
//  CartViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxCocoa
import RxSwift

struct CartViewModel {
    var cart = BehaviorRelay<Cart>(value: Cart.empty())
}

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
                    .catchErrorJustReturn(Cart.empty())
            }
            .do(onNext: { cart in
                self.cart.accept(cart)
            })

        return Output(cart: cart)
    }
}

protocol CartViewModelInput {
    var viewWillAppear: Observable<Void> { get }
}

protocol CartViewModelOutput {
    var cart: Observable<Cart> { get }
}
