//
//  Builder.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 24/11/2020.
//

import UIKit

internal struct Builder {
    internal static func build(
        _ scene: Scene,
        with dependencies: DependencyContainer,
        coordinator: Coordinator) -> UIViewController {
        switch scene {
        case .auth:
            return buildAuth(with: dependencies)
        case .root:
            return buildRoot(with: dependencies)
        case .categories(let category):
            return buildCategories(with: dependencies, category: category)
        case .products(let category):
            return buildProducts(with: dependencies, category: category)
        case .product(let product):
            return buildProduct(with: dependencies, product: product)
        case .orderConfirm(let order):
            return buildOrderConfirm(with: dependencies, order: order)
        case .order(let order):
            return buildOrder(with: dependencies, order: order)
        case .user:
            return buildUser(with: dependencies)
        }
    }

    private static func buildAuth(
        with dependencies: DependencyContainer) -> UIViewController {
        let vm = AuthViewModel(dependencies)
        let vc = AuthViewController(viewModel: vm)

        return vc
    }

    private static func buildRoot(
        with dependencies: DependencyContainer) -> UIViewController {
        let categoriesVc = buildCategories(with: dependencies).embedInNav()
        let cartVc = buildCart(with: dependencies)
        let userVc = buildUser(with: dependencies)
        let tabVm = TabBarViewModel(dependencies)
        let tabVc = TabBarController(viewModel: tabVm, vcs: [categoriesVc, cartVc, userVc])
        tabVc.selectedViewController = categoriesVc

        return tabVc
    }

    private static func buildCart(with dependencies: DependencyContainer) -> UIViewController {
        let vm = CartViewModel(dependencies)
        let vc = CartViewController(viewModel: vm).embedInNav()

        return vc
    }

    private static func buildCategories(
        with dependencies: DependencyContainer,
        category: Category?=nil) -> UIViewController {
        let vm = CategoriesViewModel(dependencies, parentCategory: category)
        let vc = CategoriesViewController(viewModel: vm)

        return vc
    }

    private static func buildProducts(
        with dependencies: DependencyContainer,
        category: Category?) -> UIViewController {
        let vm = ProductsViewModel(dependencies, category: category)
        let vc = ProductsViewController(viewModel: vm)

        return vc
    }

    private static func buildProduct(
        with dependencies: DependencyContainer,
        product: Product) -> UIViewController {
        let vm = ProductViewModel(dependencies, product: product)
        let vc = ProductViewController(viewModel: vm)

        return vc
    }

    private static func buildOrderConfirm(
        with dependencies: DependencyContainer,
        order: Order) -> UIViewController {
        let vm = OrderConfirmViewModel(dependencies, order: order)
        let vc = OrderConfirmViewController(viewModel: vm).embedInNav()

        return vc
    }

    private static func buildOrder(
        with dependencies: DependencyContainer,
        order: Order) -> UIViewController {
        let vm = OrderViewModel(dependencies, order: order)
        let vc = OrderViewController(viewModel: vm)

        return vc
    }

    private static func buildUser(
        with dependencies: DependencyContainer) -> UIViewController {
        let vm = UserViewModel(dependencies)
        let vc = UserViewController(viewModel: vm).embedInNav()

        return vc
    }
}
