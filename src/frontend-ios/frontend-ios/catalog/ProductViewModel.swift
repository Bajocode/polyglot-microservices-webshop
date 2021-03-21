//
//  ProductViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 21/11/2020.
//

import RxSwift
import RxCocoa

protocol ProductViewModelInput {
    var viewWillAppear: Observable<Void> { get }
    var upsertCartButtonTap: Driver<Void> { get }
}

protocol ProductViewModelOutput {
    var image: Driver<UIImage> { get }
    var cartUpdate: Driver<Void> { get }
}

internal struct ProductViewModel {
    typealias Dependencies = CartServiceDependency & IdentityServiceDependency

    let dependencies: Dependencies
    let product: Product

    init(_ dependencies: Dependencies, product: Product) {
        self.dependencies = dependencies
        self.product = product
    }
}

extension ProductViewModel: ReactiveTransforming {
    struct Input: ProductViewModelInput {
        let viewWillAppear: Observable<Void>
        let upsertCartButtonTap: Driver<Void>
    }
    struct Output: ProductViewModelOutput {
        var image: Driver<UIImage>
        var cartUpdate: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let image = Observable.combineLatest(
            input.viewWillAppear,
            dependencies.identityService.sharedToken)
            .flatMapLatest { _, token in
                MicroserviceClient.execute(MediaRequest.GetImageData(token, imagePath: self.product.imagepath))
                    .debug()
                    .map { UIImage(data: $0) ?? UIImage() }
                    .asDriver(onErrorJustReturn: UIImage())
            }
            .asDriver(onErrorJustReturn: UIImage())
        let cartUpdate = input.upsertCartButtonTap
            .do(onNext:  { dependencies.cartService.upsert(CartItem.fromProduct(product)) })

        return Output(
            image: image,
            cartUpdate: cartUpdate
        )
    }
}
