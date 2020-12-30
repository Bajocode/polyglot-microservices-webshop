//
//  DependencyContainer.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 24/11/2020.
//

import Foundation

protocol IdentityServiceDependency {
    var identityService: IdentityService { get }
}

protocol CatalogServiceDependency {
    var catalogService: CatalogService { get }
}

protocol CartServiceDependency {
    var cartService: CartService { get }
}

internal struct DependencyContainer: IdentityServiceDependency, CatalogServiceDependency, CartServiceDependency {
    internal let identityService: IdentityService
    internal let catalogService: CatalogService
    internal let cartService: CartService

    internal init(_ identityService: IdentityService, _ catalogService: CatalogService, _ cartService: CartService) {
        self.identityService = identityService
        self.catalogService = catalogService
        self.cartService = cartService
    }
}
