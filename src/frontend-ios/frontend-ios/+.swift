//
//  +.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import UIKit

extension UIView {
    func constrainEdgesToSuper(insets: UIEdgeInsets = .zero) {
        guard let superView = superview else {
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: insets.left).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -insets.right).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: insets.bottom).isActive = true
    }
}

extension UIViewController {
    func extractFromNav() -> UIViewController {
        if let nav = self as? UINavigationController {
            return nav.viewControllers.first!
        } else {
            return self
        }
    }

    func embedInNav() -> UINavigationController {
        if let nav = self as? UINavigationController {
            return nav
        } else {
            return UINavigationController(rootViewController: self)
        }
    }

    func extractFromTab() -> UIViewController {
        if let tab = self as? UITabBarController {
            return tab.selectedViewController!
        } else {
            return self
        }
    }
}
