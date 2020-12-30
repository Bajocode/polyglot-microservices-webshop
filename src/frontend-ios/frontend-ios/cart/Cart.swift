//
//  Cart.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Foundation

struct Cart: Codable {
    let userid: String
    var items: [CartItem]

    static func empty() -> Cart {
        return Cart(userid: "", items: [])
    }
}

struct CartItem {
    let productid: String
    var quantity: Int
    var price: Int
    var product = Product.empty()

    static func fromProduct(_ product: Product) -> CartItem {
        return CartItem(
            productid: product.productid,
            quantity: 1,
            price: product.price,
            product: product
        )
    }

    static func empty() -> CartItem {
        return CartItem(productid: "", quantity: 0, price: 0)
    }

    private enum CodingKeys: String, CodingKey {
        case productid, quantity, price
    }
}

extension CartItem: Decodable {
    init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        productid = try item.decode(String.self, forKey: .productid)
        quantity = try item.decode(Int.self, forKey: .quantity)
        price = try item.decode(Int.self, forKey: .price)
    }
}

extension CartItem: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productid, forKey: .productid)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(price, forKey: .price)
    }
}

extension CartItem: Hashable {
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.productid == rhs.productid
    }
}
