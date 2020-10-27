import Foundation

import Combine
import SwiftUI

class ProductViewModel: ObservableObject {
    private let url = "http://0.0.0.0:9001/catalog/products"
    private var task: AnyCancellable?
    
    @Published var products: [Product] = []
    
    func getAll() {
        task = URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map { $0.data }
            .decode(type: [Product].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \ProductViewModel.products, on: self)
    }
}
