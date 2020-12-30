//
//  CategoriesViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxSwift
import RxCocoa

protocol CategoriesViewModelInput {
    var viewWillAppear: Driver<Void> { get }
    var cellSelection: Driver<IndexPath> { get }
}

protocol CategoriesViewModelOutput {
    var categories: Driver<[Category]> { get }
    var categoriesOrProductsTransition: Driver<Void> { get }
}

internal struct CategoriesViewModel {
    typealias Dependencies = CatalogServiceDependency

    let dependencies: Dependencies
    let parentCategory: Category?

    init(_ dependencies: Dependencies, parentCategory: Category?=nil) {
        self.dependencies = dependencies
        self.parentCategory = parentCategory
    }
}

extension CategoriesViewModel: ReactiveTransforming {
    struct Input: CategoriesViewModelInput {
        var viewWillAppear: Driver<Void>
        var cellSelection: Driver<IndexPath>
    }
    struct Output: CategoriesViewModelOutput {
        var categories: Driver<[Category]>
        var categoriesOrProductsTransition: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let categories = input.viewWillAppear
            .flatMapLatest { return dependencies.catalogService
                .getCategories(for: parentCategory ?? Category.empty())
                .asDriver(onErrorJustReturn: []) }
        let categoriesOrProductsTransition = input.cellSelection
            .withLatestFrom(categories) { (indexPath, categories) -> Category in
                return categories[indexPath.row] }
            .do { (category) in
                let scene: Scene = category.isfinal ? .products(category) : .categories(category)
                Coordinator.shared.transition(to: scene, style: .push) }
                .map { _ in }
        
        return Output(
            categories: categories,
            categoriesOrProductsTransition: categoriesOrProductsTransition
        )
    }
}


