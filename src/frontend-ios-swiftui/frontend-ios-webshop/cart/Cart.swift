import Foundation

struct Cart: Codable {
    let userId: String
    let cartItems: [CartItem]
}
