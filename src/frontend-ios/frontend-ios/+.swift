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

extension UIImageView {
    func setImage(for url: URL?, qos: DispatchQoS.QoSClass = .background) {
        guard let url = url else {
            image = nil
            return
        }

        let req = try! URLRequest(url: "", method: .get, headers: ["Authorization": "Bearer "])

        DispatchQueue.global(qos: qos).async { [weak self] in
            URLSession.shared.dataTask(with: url) { data, response, error in
                var imageResult: UIImage?

                if let data = data, let image = UIImage(data: data) {
                    imageResult = image
                } else {
                    print("Fetch image error: \(error?.localizedDescription ?? "n/a")")
                }

                DispatchQueue.main.async {
                    self?.image = imageResult
                }
            }
        }
    }
}
