//
//  OrderDetail.swift
//  frontend-ios-webshop
//
//  Created by Fabijan Bajo on 24/10/2020.
//

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
