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
        let catalogVc = CatalogViewController()
        tc.viewControllers = [catalogVc]
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = tc
        window?.makeKeyAndVisible()

        return true
    }
}
