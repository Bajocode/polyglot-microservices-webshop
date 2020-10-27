import SwiftUI

struct CartList: View {
    @ObservedObject var viewModel = CartViewModel()
    var body: some View {
        NavigationView {
            List(viewModel.cart.cartItems, id: \.self) { cartItem in
                CartRow(cartItem: cartItem)
            }
            .onAppear {
                self.viewModel.get()
            }
        }
    }
}
