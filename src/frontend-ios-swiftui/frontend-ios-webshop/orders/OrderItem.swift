import Foundation

struct OrderItem: Decodable, Hashable {
    let userId: String
    let orderId: String
    let total: Int
}
