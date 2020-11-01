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
        let tc = UITabBarController()
        let cartService = CartService()
        let catalogVm = CatalogViewModel(cartService)
        let catalogVc = CatalogViewController(viewModel: catalogVm)
        let cartVc = CartViewController()
        tc.viewControllers = [UINavigationController(rootViewController: catalogVc), cartVc]
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = tc
        window?.makeKeyAndVisible()

        return true
    }
}
