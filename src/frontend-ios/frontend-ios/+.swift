//
//  +.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import UIKit

extension UIView {
    internal func constrainEdgesToSuper(insets: UIEdgeInsets = .zero) {
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
    internal func extractFromNav() -> UIViewController {
        if let nav = self as? UINavigationController {
            return nav.viewControllers.first!
        } else {
            return self
        }
    }

    internal func embedInNav() -> UINavigationController {
        if let nav = self as? UINavigationController {
            return nav
        } else {
            return UINavigationController(rootViewController: self)
        }
    }

    internal func extractFromTab() -> UIViewController {
        if let tab = self as? UITabBarController {
            return tab.selectedViewController!
        } else {
            return self
        }
    }
}

extension UIImageView {
    func setImageFromS3(path: String, qos: DispatchQoS.QoSClass = .background) {
        guard let req = try? URLRequest(
                url: MediaRequest.GetImageData(imagePath: path).url,
                method: .get,
                headers: ["Authorization": "Bearer \(IdentityService.shared.token.token)"]) else {
            image = nil
            return
        }

        DispatchQueue.global(qos: qos).async { [weak self] in
            URLSession.shared.dataTask(with: req) { data, response, error in
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
            .resume()
        }
    }
}
