import Foundation

import Combine
import SwiftUI

class CartViewModel: ObservableObject {
    private let url = "http://0.0.0.0:9003/cart"
    private var task: AnyCancellable?
    
    @Published var cart: Cart = Cart(userId: "", cartItems: [])
    
    func get() {
        task = URLSession.shared.dataTaskPublisher(for: URL(string: url+"/85a3a5d5-e50f-463b-a757-9acf5515644a")!)
            .map { $0.data }
            .decode(type: Cart.self, decoder: JSONDecoder())
            .replaceError(with: cart)
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \CartViewModel.cart, on: self)
    }
}
