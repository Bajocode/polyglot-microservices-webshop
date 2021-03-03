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
}

protocol OrderConfirmViewModelOutput {
    var order: Driver<Order> { get }
    var orderPost: Driver<Void> { get }
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
    }

    struct Output: OrderConfirmViewModelOutput {
        var order: Driver<Order>
        var orderPost: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let orderPost = Observable.combineLatest(input.confirmButtonTap, dependencies.identityService.sharedToken)
            .flatMapLatest { _, token in
                MicroserviceClient.execute(OrderRequest.Post(token, order: order))
                    .do(onSuccess: { (order) in
                        Coordinator.shared.alert(title: "Success", message: "sfs")
                    })
                    .asDriver(onErrorJustReturn: Order.empty())
            }
            .asDriver(onErrorJustReturn: Order.empty())
            .map { _ in }

        return Output(
            order: Driver.of(order),
            orderPost: orderPost
        )
    }
}
