//
//  UserViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 12/12/2020.
//

import RxSwift
import RxCocoa

protocol UserViewModelInput {
    var viewWillAppear: Observable<Void> { get }
    var cellSelection: Observable<IndexPath> { get }
    var logoutButtonTap: Observable<Void> { get }
}

protocol UserViewModelOutput {
    var orders: Driver<[Order]> { get }
    var orderTransition: Driver<Void> { get }
    var userLogout: Driver<Void> { get }
}

internal struct UserViewModel {
    typealias Dependencies = IdentityServiceDependency

    private let dependencies: Dependencies

    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension UserViewModel: ReactiveTransforming {
    internal struct Input: UserViewModelInput {
        var viewWillAppear: Observable<Void>
        var cellSelection: Observable<IndexPath>
        var logoutButtonTap: Observable<Void>
    }
    internal struct Output: UserViewModelOutput {
        var orders: Driver<[Order]>
        var orderTransition: Driver<Void>
        var userLogout: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let orders = input.viewWillAppear.flatMapLatest {
            MicroserviceClient
                .execute(OrderRequest.Get(IdentityService.shared.token))
                .asDriver(onErrorJustReturn: [])
            }
            .asDriver(onErrorJustReturn: [])
        let orderTransition = input.cellSelection
            .withLatestFrom(orders) { (indexPath, orders) -> Order in
                return orders[indexPath.row]
            }
            .do { Coordinator.shared.transition(to: .order($0), style: .push) }
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        let userLogout = input.logoutButtonTap
            .do { _ in Coordinator.shared.transition(to: .auth, style: .entry) }
            .asDriver(onErrorJustReturn: ())

        return Output(
            orders: orders,
            orderTransition: orderTransition,
            userLogout: userLogout)
    }
}
