//
//  Category.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Foundation

struct Category: Hashable, Decodable {
    let categoryid: Int
    let parentid: Int
    let name: String
    let isfinal: Bool

    static func empty() -> Category {
        return Category(
            categoryid: 0,
            parentid: 0,
            name: "",
            isfinal: false)
    }
}
