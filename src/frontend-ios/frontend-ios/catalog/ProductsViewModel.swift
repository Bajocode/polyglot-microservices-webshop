//
//  ProductsViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxSwift
import RxCocoa

protocol ProductsViewModelInput {
    var viewWillAppear: Observable<Void> { get }
    var addButtonTap: Observable<Product> { get }
    var cellSelection: Observable<IndexPath> { get }
}

protocol ProductsViewModelOutput {
    var products: Driver<[Product]> { get }
    var cartUpdate: Driver<Void> { get }
    var productTransition: Driver<Void> { get }
}

internal struct ProductsViewModel {
    typealias Dependencies = CatalogServiceDependency & CartServiceDependency

    let dependencies: Dependencies
    let category: Category?

    init(_ dependencies: Dependencies, category: Category?=nil) {
        self.dependencies = dependencies
        self.category = category
    }
}

extension ProductsViewModel: ReactiveTransforming {
    internal struct Input: ProductsViewModelInput {
        var viewWillAppear: Observable<Void>
        let addButtonTap: Observable<Product>
        var cellSelection: Observable<IndexPath>
    }
    internal struct Output: ProductsViewModelOutput {
        var products: Driver<[Product]>
        let cartUpdate: Driver<Void>
        var productTransition: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let products = input.viewWillAppear
            .flatMapLatest {
                dependencies.catalogService
                    .getProducts(for: category!)
                    .asDriver(onErrorJustReturn: [])
            }
            .asDriver(onErrorJustReturn: [])

        let cartUpdate = input.addButtonTap
            .map { CartItem.fromProduct($0) }
            .do(onNext:  { dependencies.cartService.upsert($0) })
            .map { _ in }
            .asDriver(onErrorJustReturn:())
        let productTransition = input.cellSelection
            .withLatestFrom(products) { (indexPath, products) -> Product in
                return products[indexPath.row]
            }
            .do { Coordinator.shared.transition(to: .product($0), style: .push) }
            .map { _ in }
            .asDriver(onErrorJustReturn: ())

        return Output(
            products: products,
            cartUpdate: cartUpdate,
            productTransition: productTransition
        )
    }
}


