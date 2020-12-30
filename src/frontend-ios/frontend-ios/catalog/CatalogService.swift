//
//  CatalogService.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 08/11/2020.
//

import RxSwift
import RxCocoa

internal final class CatalogService {
    @discardableResult internal func getAllCategories() -> Observable<[Category]> {
        return MicroserviceClient
            .execute(CatalogRequest.GetCategories())
            .asObservable()
    }

    @discardableResult internal func getCategories(for parent: Category) -> Observable<[Category]> {
        return MicroserviceClient
            .execute(CatalogRequest.GetCategories(["parent": parent.categoryid]))
            .asObservable()
    }

    @discardableResult internal func getAllProducts() -> Observable<[Product]> {
        return MicroserviceClient
            .execute(CatalogRequest.GetProducts())
            .asObservable()
    }

    @discardableResult internal func getProducts(for category: Category) -> Observable<[Product]> {
        return MicroserviceClient
            .execute(CatalogRequest.GetProducts(["category": category.categoryid]))
            .asObservable()
    }

    @discardableResult internal func getProducts(for cart: Cart) -> Observable<[Product]> {
        let items = cart.items
        let ids = items.map { $0.productid }.joined(separator: ",")
        return MicroserviceClient
            .execute(CatalogRequest.GetProducts(["ids": ids]))
            .asObservable()
    }

    @discardableResult internal func getProducts(for order: Order) -> Observable<[Product]> {
        let items = order.items
        let ids = items.map { $0.productid }.joined(separator: ",")
        return MicroserviceClient
            .execute(CatalogRequest.GetProducts(["ids": ids]))
            .asObservable()
    }

}
