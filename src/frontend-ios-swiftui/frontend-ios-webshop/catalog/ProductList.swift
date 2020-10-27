import SwiftUI

struct ProductList: View {
    @ObservedObject var viewModel = ProductViewModel()
    var body: some View {
        NavigationView {
            List(viewModel.products, id: \.self) { product in
                ProductRow(product: product)
                    .onTapGesture {
                        print(product.name)
                    }
            }
            .onAppear {
                self.viewModel.getAll()
            }
        }
    }
}
