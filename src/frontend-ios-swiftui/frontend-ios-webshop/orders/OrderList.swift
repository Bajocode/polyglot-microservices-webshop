import SwiftUI

struct OrderList: View {
    @ObservedObject var viewModel = OrderViewModel()
    var body: some View {
        NavigationView {
            List(viewModel.orders, id: \.self) { order in
                NavigationLink(destination: OrderDetail(order: order)) {
                    OrderRow(order: order)
                }
            }
            .onAppear {
                self.viewModel.getAll()
            }
        }
    }
}
