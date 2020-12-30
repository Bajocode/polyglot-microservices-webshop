//
//  CartService.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxCocoa
import RxSwift

class CartService {
    internal var sharedCart: Observable<Cart> { return cart.asObservable() }
    private var cart = BehaviorRelay<Cart>(value: Cart.empty())
    private var items: [CartItem] {
        get{ return cart.value.items }
        set {
            var current = cart.value
            current.items = newValue
            cart.accept(current)
            put()
        }
    }
    private let bag = DisposeBag()

    // Get from /cart, update behavior and return result
    @discardableResult internal func get() -> Observable<Cart> {
        return MicroserviceClient.execute(CartRequest.Get())
            .asObservable()
            .do { self.cart.accept($0) }
    }

    // Push to /cart and bind result back to behaviorrelay
    // If cart empty, it was due to empty put
    internal func put() {
        _ = MicroserviceClient.execute(CartRequest.Put(cart: cart.value))
            .asObservable()
            .subscribe()
            .disposed(by: bag)
    }

    // Add cartitem to items
    internal func upsert(_ item: CartItem) {
        if let index = items.firstIndex(where: { $0.productid == item.productid }) {
            updateItems(with: item, index: index)
        } else {
            items.append(item)
        }
    }
    private func updateItems(with item: CartItem, index: Int) {
        if item.quantity < 1 {
            items.remove(at: index)
            return
        }

        var updating = items[index]
        updating.quantity = item.quantity
        updating.price = item.product.price * updating.quantity
        items[index] = updating
    }

    // Add product to cart items, update behavior and return cart
    @discardableResult internal func populated(with products: [Product]) -> Cart {
        var cart = self.cart.value

        let items = cart.items.map { item -> CartItem in
            guard let product = products.first(where: { $0.productid == item.productid }) else {
                return item
            }
            var updating = item
            updating.product = product

            return updating
        }

        cart.items = items
        self.cart.accept(cart)

        return cart
    }
}
