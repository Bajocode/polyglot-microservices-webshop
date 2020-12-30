//
//  Order.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 24/11/2020.
//

import Foundation

internal struct Order {
    var orderid: String = ""
    let userid: String
    var items: [OrderItem]
    let price: Int

    internal static func empty() -> Order {
        return Order(orderid: "", userid: "", items: [], price: 0)
    }

    internal static func from(_ cart: Cart) -> Order {
        return Order(
            orderid: "",
            userid: cart.userid,
            items: cart.items.map { OrderItem.from($0) },
            price: cart.items
                .map { $0.price }
                .reduce(0, +)
        )
    }
}

extension Order: Encodable {
    private enum EncodingKeys: String, CodingKey {
        case userid, items, price
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(userid, forKey: .userid)
        try container.encode(items, forKey: .items)
        try container.encode(price, forKey: .price)
    }
}

extension Order: Decodable {
    private enum DecodingKeys: String, CodingKey {
        case orderid, userid, items, price
    }

    init(from decoder: Decoder) throws {
        let dto = try decoder.container(keyedBy: DecodingKeys.self)
        orderid = try dto.decode(String.self, forKey: .orderid)
        userid = try dto.decode(String.self, forKey: .userid)
        price = try dto.decode(Int.self, forKey: .price)

        if let items = try dto.decodeIfPresent([OrderItem].self, forKey: .items) {
            self.items = items
        } else {
            self.items = []
        }
    }
}

internal struct OrderItem {
    var orderid: String = ""
    let productid: String
    let quantity: Int
    let price: Int
    var product: Product = Product.empty()

    internal static func empty() -> OrderItem {
        return OrderItem(productid: "", quantity: 0, price: 0)
    }

    internal static func from(_ cartItem: CartItem) -> OrderItem {
        return OrderItem(
            productid: cartItem.productid,
            quantity: cartItem.quantity,
            price: cartItem.price,
            product: cartItem.product)
    }
}

extension OrderItem: Encodable {
    private enum EncodingKeys: String, CodingKey {
        case productid, quantity, price
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(productid, forKey: .productid)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(price, forKey: .price)
    }
}

extension OrderItem: Decodable {
    private enum DecodingKeys: String, CodingKey {
        case orderid, productid, quantity, price
    }

    init(from decoder: Decoder) throws {
        let dto = try decoder.container(keyedBy: DecodingKeys.self)
        orderid = try dto.decode(String.self, forKey: .orderid)
        productid = try dto.decode(String.self, forKey: .productid)
        quantity = try dto.decode(Int.self, forKey: .quantity)
        price = try dto.decode(Int.self, forKey: .price)
    }
}

