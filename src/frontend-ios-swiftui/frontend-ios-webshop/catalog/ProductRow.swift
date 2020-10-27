import SwiftUI

struct ProductRow: View {
    private let product: Product
    init(product: Product) {
        self.product = product
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15, content: {
                Text(product.name)
                Text(product.price.description)
            })
        }
    }
}
