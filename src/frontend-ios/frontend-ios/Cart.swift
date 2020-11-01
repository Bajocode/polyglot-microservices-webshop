//
//  Cart.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Foundation

struct Cart: Codable {
    let userId: String
    var cartItems: [CartItem]

    static func empty() -> Cart {
        return Cart(
            userId: "",
            cartItems: []
        )
    }
}

struct CartItem: Codable {
    let productId: String
    let quantity: Int
    let price: Int
}
