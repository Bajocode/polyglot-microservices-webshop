//
//  OrderViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 21/11/2020.
//

import RxSwift
import RxCocoa

protocol OrderViewModelInput {
    var viewWillAppear: Observable<Void> { get }
    var cellSelection: Observable<IndexPath> { get }
}

protocol OrderViewModelOutput {
    var order: Driver<Order> { get }
    var productTransition: Driver<Void> { get }
}

internal struct OrderViewModel {
    typealias Dependencies = CartServiceDependency & CatalogServiceDependency & IdentityServiceDependency

    let dependencies: Dependencies
    let order: Order

    init(_ dependencies: Dependencies, order: Order) {
        self.dependencies = dependencies
        self.order = order
    }
}

extension OrderViewModel: ReactiveTransforming {
    internal struct Input: OrderViewModelInput {
        var viewWillAppear: Observable<Void>
        var cellSelection: Observable<IndexPath>
    }
    internal struct Output: OrderViewModelOutput {
        var order: Driver<Order>
        var productTransition: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let order = input.viewWillAppear.flatMapLatest {
            MicroserviceClient
                .execute(OrderRequest.GetOne(order: self.order))
                .asDriver(onErrorJustReturn: Order.empty())
            }
            .asDriver(onErrorJustReturn: Order.empty())
            .flatMapLatest { order -> Driver<Order> in
                return dependencies.catalogService.getProducts(for: order)
                    .map { products in populateItems(for: order, with: products) }
                    .asDriver(onErrorJustReturn: Order.empty())
            }
            .asDriver(onErrorJustReturn: Order.empty())
        let productTransition = input.cellSelection
            .withLatestFrom(order) { (indexPath, order) -> OrderItem in
                return order.items[indexPath.row]
            }
            .do { Coordinator.shared.transition(to: .product($0.product), style: .push) }
            .map { _ in }
            .asDriver(onErrorJustReturn: ())

        return Output(
            order: order,
            productTransition: productTransition
        )
    }

    private func populateItems(for order: Order, with products: [Product]) -> Order {
        let items = order.items.map { item -> OrderItem in
            guard let product = products.first(where: { $0.productid == item.productid }) else {
                return item
            }
            var updating = item
            updating.product = product

            return updating
        }
        var newOrder = order
        newOrder.items = items

        return newOrder
    }
}
