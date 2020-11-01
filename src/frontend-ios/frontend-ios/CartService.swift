//
//  CartService.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxCocoa
import RxSwift

class CartService {
    private let bag = DisposeBag()
    private var cart = BehaviorRelay<Cart>(value: Cart.empty())
    private var cartItems: [CartItem] {
        get{
            return cart.value.cartItems
        }
        set {
            print("SYNCING")
            var currentCart = cart.value
            currentCart.cartItems = newValue
            cart.accept(currentCart)
            sync(isOutgoing: true)
        }
    }

    @discardableResult func fetch() -> Cart {
        sync()

        return cart.value
    }

    func insert(_ cartItem: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.productId == cartItem.productId }) {
            cartItems[index] = cartItem
        } else {
            cartItems.append(cartItem)
        }
    }

    private func update() {

    }

    private func sync(isOutgoing: Bool=false) {
        if isOutgoing {
            return MicroserviceClient.execute(CartRequest.Put(cart: cart.value))
                .asObservable()
                .observeOn(MainScheduler.instance)
                .bind(to: cart)
                .disposed(by: bag)
        } else {
            return MicroserviceClient.execute(CartRequest.Get())
                .asObservable()
                .observeOn(MainScheduler.instance)
                .bind(to: cart)
                .disposed(by: bag)
        }
    }
}
