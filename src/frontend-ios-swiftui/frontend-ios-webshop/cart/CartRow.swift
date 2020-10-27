import SwiftUI

struct CartRow: View {
    private let cartItem: CartItem
    init(cartItem: CartItem) {
        self.cartItem = cartItem
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15, content: {
                Text(cartItem.productId)
            })
        }
    }
}
