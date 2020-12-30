//
//  ProductViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 21/11/2020.
//

import RxSwift
import RxCocoa

protocol ProductViewModelInput {
    var upsertCartButtonTap: Driver<Void> { get }
}

protocol ProductViewModelOutput {
    var cartUpdate: Driver<Void> { get }
}

internal struct ProductViewModel {
    typealias Dependencies = CartServiceDependency

    let dependencies: Dependencies
    let product: Product

    init(_ dependencies: Dependencies, product: Product) {
        self.dependencies = dependencies
        self.product = product
    }
}

extension ProductViewModel: ReactiveTransforming {
    struct Input: ProductViewModelInput {
        var upsertCartButtonTap: Driver<Void>
    }
    struct Output: ProductViewModelOutput {
        var cartUpdate: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let cartUpdate = input.upsertCartButtonTap
            .do(onNext:  { dependencies.cartService.upsert(CartItem.fromProduct(product)) })

        return Output(
            cartUpdate: cartUpdate
        )
    }
}
