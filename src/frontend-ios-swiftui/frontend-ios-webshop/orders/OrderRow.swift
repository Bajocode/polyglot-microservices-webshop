import SwiftUI

struct OrderRow: View {
    private let order: Order
    init(order: Order) {
        self.order = order
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15, content: {
                Text(order.userId)
                Text(order.orderId)
                Text(order.total.description)
            })
        }
    }
}
