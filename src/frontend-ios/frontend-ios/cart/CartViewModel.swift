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
    var authTransition: Driver<Void> { get }
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
        var viewWillAppear: Observable<Void>
        var quantityStep: Observable<CartItem>
        var orderButtonTap: Observable<Void>
    }
    struct Output: CartViewModelOutput {
        var cart: Driver<Cart>
        var cartUpdate: Driver<Void>
        var orderTransition: Driver<Void>
        var authTransition: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let cartVwa = input.viewWillAppear
            .flatMapLatest {
                return dependencies.cartService.get()
                .catchErrorJustReturn(Cart.empty())
            }
            .share(replay: 1)
            .flatMapLatest { cart -> Observable<Cart> in
                return dependencies.catalogService.getProducts(for: cart)
                    .map { dependencies.cartService.populated(with: $0) }
                    .catchErrorJustReturn(Cart.empty())
            }
            .share(replay: 1)
        let cartLatest = dependencies.cartService.sharedCart
        let cart = Observable.merge(cartVwa, cartLatest)
        let cartUpdate = input.quantityStep
            .do(onNext:  { dependencies.cartService.upsert($0) })
            .map { _ in }
            .asDriver(onErrorJustReturn:())
        let authTransition = input.orderButtonTap
            .takeWhile { !dependencies.identityService.isLoggedIn() }
            .do { _ in Coordinator.shared.transition(to: .auth, style: .modal()) }
            .asDriver(onErrorJustReturn: ())
        let orderTransition = input.orderButtonTap
            .takeWhile { dependencies.identityService.isLoggedIn() }
            .withLatestFrom(cart)
            .map { Order.from($0) }
            .do { order in Coordinator.shared.transition(to: .orderConfirm(order), style: .modal()) }
            .map { _ in }
            .asDriver(onErrorJustReturn: ())

        return Output(cart: cart.asDriver(onErrorJustReturn: Cart.empty()),
                      cartUpdate: cartUpdate,
                      orderTransition: orderTransition,
                      authTransition: authTransition)
    }
}
