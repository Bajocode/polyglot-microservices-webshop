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
    private var token: Token = Token.empty()
    private var items: [CartItem] {
        get{ return cart.value.items }
        set {
            var current = cart.value
            current.items = newValue
            cart.accept(current)
            put(token)
        }
    }
    private let bag = DisposeBag()

    @discardableResult internal func get(_ token: Token) -> Observable<Cart> {
        setToken(token: token)
        return MicroserviceClient.execute(CartRequest.Get(token))
            .asObservable()
            .do { self.cart.accept($0) }
    }

    internal func put(_ token: Token) {
        setToken(token: token)
        _ = MicroserviceClient.execute(CartRequest.Put(token, cart: cart.value))
            .asObservable()
            .subscribe()
            .disposed(by: bag)
    }

    internal func upsert(_ item: CartItem) {
        if let index = items.firstIndex(where: { $0.productid == item.productid }) {
            updateItems(with: item, index: index)
        } else {
            items.append(item)
        }
    }

    @discardableResult internal func populateItems(with products: [Product]) -> Cart {
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

    private func setToken(token: Token) {
        self.token = token
    }
}
