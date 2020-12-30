//
//  Product.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Foundation

struct Product: Hashable, Decodable {
    let productid: String
    let name: String
    let price: Int

    static func empty() -> Product {
        return Product(
            productid: "",
            name: "",
            price: 0)
    }
}
