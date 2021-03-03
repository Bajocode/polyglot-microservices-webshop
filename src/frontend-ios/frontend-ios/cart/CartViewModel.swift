//
//  CartViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxSwift
import RxCocoa

protocol CartViewModelInput {
    var viewWillAppear: Observable<Void> { get }
    var quantityStep: Observable<CartItem> { get }
    var orderButtonTap: Observable<Void> { get }
}

protocol CartViewModelOutput {
    var cart: Driver<Cart> { get }
    var cartUpdate: Driver<Void> { get }
    var orderTransition: Driver<Void> { get }
}

struct CartViewModel {
    typealias Dependencies = CartServiceDependency & CatalogServiceDependency & IdentityServiceDependency

    private let dependencies: Dependencies

    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension CartViewModel: ReactiveTransforming {
    struct Input: CartViewModelInput {
        let viewWillAppear: Observable<Void>
        let quantityStep: Observable<CartItem>
        let orderButtonTap: Observable<Void>
    }
    struct Output: CartViewModelOutput {
        let cart: Driver<Cart>
        let cartUpdate: Driver<Void>
        let orderTransition: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let cartVwa = Observable
            .combineLatest(input.viewWillAppear, dependencies.identityService.sharedToken)
            .flatMapLatest { _, token in
                return dependencies.cartService.get(token)
                .catchErrorJustReturn(Cart.empty())
            }
            .share(replay: 1)
            .flatMapLatest { cart -> Observable<Cart> in
                return dependencies.catalogService.getProducts(for: cart)
                    .map { products in dependencies.cartService.populateItems(with: products) }
                    .catchErrorJustReturn(Cart.empty())
            }
            .share(replay: 1)
        let cartLatest = dependencies.cartService.sharedCart
        let cart = Observable.merge(cartVwa, cartLatest)
        let cartUpdate = input.quantityStep
            .do(onNext:  { dependencies.cartService.upsert($0) })
            .map { _ in }
            .asDriver(onErrorJustReturn:())
        let orderTransition = input.orderButtonTap
            .withLatestFrom(cart)
            .map { Order.from($0) }
            .do { order in Coordinator.shared.transition(to: .orderConfirm(order), style: .modal()) }
            .map { _ in }
            .asDriver(onErrorJustReturn: ())

        return Output(cart: cart.asDriver(onErrorJustReturn: Cart.empty()),
                      cartUpdate: cartUpdate,
                      orderTransition: orderTransition)
    }
}
