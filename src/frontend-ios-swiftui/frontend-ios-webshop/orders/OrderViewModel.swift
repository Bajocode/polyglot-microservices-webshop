import Foundation

import Combine
import SwiftUI

class OrderViewModel: ObservableObject {
    private let url = "http://0.0.0.0:9002/orders"
    private var task: AnyCancellable?
    
    @Published var orders: [Order] = []
    
    func getAll() {
        task = URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map { $0.data }
            .decode(type: [Order].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \OrderViewModel.orders, on: self)
    }
}
