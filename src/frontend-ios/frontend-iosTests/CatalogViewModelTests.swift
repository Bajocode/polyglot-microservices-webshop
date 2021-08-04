//
//  CatalogViewModelTests.swift
//  frontend-iosTests
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import XCTest
import RxSwift
import RxBlocking
@testable import frontend_ios

class CategoriesViewModelTests: XCTestCase {

    var sut: CategoriesViewModel!
    var bag: DisposeBag!
    var scheduler: ConcurrentDispatchQueueScheduler!

    override func setUpWithError() throws {
        try! super.setUpWithError()

        let identityService = IdentityService()
        let catalogService = CatalogService()
        let cartService = CartService()
        let container = DependencyContainer(identityService, catalogService, cartService)
        sut = CategoriesViewModel(container)
        bag = DisposeBag()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }

    override func tearDownWithError() throws {

        try! super.tearDownWithError()
    }

    func testExample() throws {
        let input = CategoriesViewModel.Input(
            viewWillAppear: PublishSubject<Void>().asDriver(onErrorJustReturn: ()),
            cellSelection: PublishSubject<IndexPath>().asDriver(onErrorJustReturn: IndexPath.init()))
        let output = sut.transform(input)

        let categories = try! output.categories.toBlocking().first()!

        XCTAssertTrue(categories.count == 6)
    }
}
