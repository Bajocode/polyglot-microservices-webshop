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

class CatalogViewModelTests: XCTestCase {

    var sut: CatalogViewModel!
    var bag: DisposeBag!
    var scheduler: ConcurrentDispatchQueueScheduler!

    override func setUpWithError() throws {
        try! super.setUpWithError()

        sut = CatalogViewModel()
        bag = DisposeBag()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }

    override func tearDownWithError() throws {

        try! super.tearDownWithError()
    }

    func testExample() throws {
        let output = sut.transform(CatalogViewModel.Input(viewWillAppear: Observable.of()))
            .products.subscribeOn(scheduler)
        let result = try output.toBlocking().materialize()

        print(result)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
