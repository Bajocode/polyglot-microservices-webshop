import SwiftUI

struct OrderDetail: View {
    var order: Order
    var body: some View {
        VStack {
            Text(order.userId)
        }
        .navigationBarTitle(Text(order.total.description))
    }
}
