//
//  AppDelegate.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 26/10/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        let identityService = IdentityService()
        let catalogService = CatalogService()
        let cartService = CartService()
        let container = DependencyContainer(identityService, catalogService, cartService)

        Coordinator.construct(Coordinator.Config(window: window!, container: container))

        if identityService.isLoggedIn() {
            Coordinator.shared.transition(to: .root, style: .entry, animated: false)
        } else {
            Coordinator.shared.transition(to: .auth, style: .entry, animated: false)
        }

        return true
    }
}
