//
//  OrderConfirmViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 24/11/2020.
//

import RxSwift
import RxCocoa

protocol OrderConfirmViewModelInput {
    var viewWillAppear: Observable<Void> { get }
    var confirmButtonTap: Observable<Void> { get }
    var cancelButtonTap: Observable<Void> { get }
}

protocol OrderConfirmViewModelOutput {
    var order: Driver<Order> { get }
    var orderPost: Driver<Void> { get }
    var orderCancel: Driver<Void> { get }
}

internal struct OrderConfirmViewModel {
    typealias Dependencies = CartServiceDependency & IdentityServiceDependency

    private let dependencies: Dependencies
    private let order: Order

    init(_ dependencies: Dependencies, order: Order) {
        self.dependencies = dependencies
        self.order = order
    }
}

extension OrderConfirmViewModel: ReactiveTransforming {
    struct Input: OrderConfirmViewModelInput {
        var viewWillAppear: Observable<Void>
        var confirmButtonTap: Observable<Void>
        var cancelButtonTap: Observable<Void>
    }

    struct Output: OrderConfirmViewModelOutput {
        var order: Driver<Order>
        var orderPost: Driver<Void>
        var orderCancel: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let successCompletion: (Order) -> Void = {
            order in Coordinator.shared.dismiss(true) {
                Coordinator.shared.alert(title: "Success",
                                         message: "Order: \(order.orderid)")}}
        let orderPost = input.confirmButtonTap.flatMapLatest {
            MicroserviceClient
                .execute(OrderRequest.Post(dependencies.identityService.sharedToken, order: order))
                .do(onSuccess: { _ in dependencies.cartService.empty(dependencies.identityService.sharedToken) },
                    afterSuccess: { order in successCompletion(order)
                })
                .debug()
                .asDriver(onErrorJustReturn: Order.empty())
            }
            .debug()
            .asDriver(onErrorJustReturn: Order.empty())
            .map { _ in }
        let orderCancel = input.cancelButtonTap
            .debug()
            .do (onNext: { Coordinator.shared.dismiss(true) })
            .asDriver(onErrorJustReturn: ())

        return Output(
            order: Driver.of(order),
            orderPost: orderPost,
            orderCancel: orderCancel
        )
    }
}
