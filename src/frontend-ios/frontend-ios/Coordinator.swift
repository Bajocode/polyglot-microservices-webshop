//
//  Coordinator.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 11/11/2020.
//

import UIKit

internal enum Scene {
    case auth,
         root,
         categories(Category?=nil),
         products(Category?=nil),
         product(Product),
         orderConfirm(Order),
         order(Order),
         user
}

internal enum TransitionStyle {
    case entry, push, modal(UIModalPresentationStyle?=nil)
}

internal final class Coordinator {
    internal static let shared = Coordinator()
    private static var config: Config?
    private let window: UIWindow
    private let container: DependencyContainer
    private var currentVc: UIViewController!

    struct Config {
        let window: UIWindow
        let container: DependencyContainer
    }

    class func construct(_ config: Config) {
        Coordinator.config = config
    }

    private init() {
        guard let config = Coordinator.config else {
            fatalError("Call construct before accessing Coordinator.shared")
        }
        window = config.window
        container = config.container
    }

    internal func transition(
        to scene: Scene,
        style: TransitionStyle,
        animated: Bool = true) {
        let vc = Builder.build(scene, with: container, coordinator: self)

        switch style {
        case .entry: handleEntry(for: vc, animated)
        case .push: handlePush(for: vc, animated)
        case .modal(let modalStyle): handleModal(for: vc, modalStyle: modalStyle, animated)
        }
    }

    internal func dismiss(_ animated: Bool, completion: (() -> Void)?=nil) {
        currentVc.dismiss(animated: animated, completion: completion)
    }

    internal func alert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        ac.addAction(okAction)
        currentVc.present(ac, animated: true, completion: nil)
    }

    internal func setCurrentVc(vc: UIViewController) {
        self.currentVc = vc
    }

    private func handleEntry(for vc: UIViewController, _ animated: Bool) {
        currentVc = vc.extractFromTab()
        window.rootViewController = vc

        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)

        self.window.makeKeyAndVisible()
    }

    private func handlePush(for vc: UIViewController, _ animated: Bool) {
        let currentNav = currentVc as? UINavigationController
        let nextVc = vc.extractFromNav()

        currentNav?.pushViewController(nextVc, animated: animated)
    }

    private func handleModal(for vc: UIViewController, modalStyle: UIModalPresentationStyle?=nil, _ animated: Bool) {
        if let style = modalStyle {
            vc.modalPresentationStyle = style
        }
        currentVc.present(vc, animated: animated, completion: nil)
    }
}
