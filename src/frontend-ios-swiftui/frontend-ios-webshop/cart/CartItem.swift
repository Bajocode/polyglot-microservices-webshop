import Foundation

struct CartItem: Codable, Hashable {
    let productId: String
    let quantity: Int
    let price: Int
}
