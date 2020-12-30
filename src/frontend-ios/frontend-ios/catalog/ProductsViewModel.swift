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
    var cellSelection: Observable<IndexPath> { get }
}

protocol ProductsViewModelOutput {
    var products: Driver<[Product]> { get }
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
    struct Input: ProductsViewModelInput {
        var viewWillAppear: Observable<Void>
        var cellSelection: Observable<IndexPath>
    }
    struct Output: ProductsViewModelOutput {
        var products: Driver<[Product]>
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
        let productTransition = input.cellSelection
            .withLatestFrom(products) { (indexPath, products) -> Product in
                return products[indexPath.row]
            }
            .do { Coordinator.shared.transition(to: .product($0), style: .push) }
            .map { _ in }
            .asDriver(onErrorJustReturn: ())

        return Output(
            products: products,
            productTransition: productTransition
        )
    }
}


