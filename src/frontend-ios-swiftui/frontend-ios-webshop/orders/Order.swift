import Foundation

struct Order: Decodable, Hashable {
    let userId: String
    let orderId: String
    let total: Int
}
