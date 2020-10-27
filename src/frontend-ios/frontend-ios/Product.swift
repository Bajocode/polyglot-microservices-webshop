//
//  Product.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Foundation

struct Product: Decodable {
    let productId: String
    let name: String
    let price: Int
}
