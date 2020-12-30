//
//  TabBarViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 23/11/2020.
//

import RxSwift
import RxCocoa
import Moya

protocol TabBarViewModelInput {
    var viewWillAppear: Observable<Void> { get }
    var tabSelect: Observable<UIViewController> { get }
}

protocol TabBarViewModelOutput {
    var cartSync: Driver<Void> { get }
    var sharedCart: Driver<Cart> { get }
    var coordinatorSync: Driver<Void> { get }
}

struct TabBarViewModel {
    typealias Dependencies = CartServiceDependency

    let dependencies: Dependencies

    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension TabBarViewModel: ReactiveTransforming {
    struct Input: TabBarViewModelInput {
        var viewWillAppear: Observable<Void>
        var tabSelect: Observable<UIViewController>
    }
    struct Output: TabBarViewModelOutput {
        var cartSync: Driver<Void>
        var sharedCart: Driver<Cart>
        var coordinatorSync: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let cartSync = input.viewWillAppear
            .flatMapLatest {
                return dependencies.cartService
                    .get()
                    .map { _ in }
                    .asDriver(onErrorJustReturn: ())
            }
            .asDriver(onErrorJustReturn: ())
        let sharedCart = dependencies.cartService
            .sharedCart
            .asDriver(onErrorJustReturn: Cart.empty())
        let coordinatorSync = input.tabSelect
            .do { Coordinator.shared.setCurrentVc(vc: $0) }
            .map { _ in }
            .asDriver(onErrorJustReturn: ())

        return Output(
            cartSync: cartSync,
            sharedCart: sharedCart,
            coordinatorSync: coordinatorSync)
    }
}
