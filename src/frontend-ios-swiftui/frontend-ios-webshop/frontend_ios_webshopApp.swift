//
//  frontend_ios_webshopApp.swift
//  frontend-ios-webshop
//
//  Created by Fabijan Bajo on 24/10/2020.
//

import SwiftUI

@main
struct frontend_ios_webshopApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ProductList().tabItem {
                    Text("Products")
                }

                OrderList().tabItem {
                    Text("Orders")
                }

                CartList().tabItem {
                    Text("Cart")
                }
            }
        }
    }
}
