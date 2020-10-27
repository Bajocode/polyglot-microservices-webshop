import Foundation

struct Product: Decodable, Hashable {
    let productId: String
    let name: String
    let price: Int
}
