//
//  CartTableViewCell.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 08/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

internal final class CartTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var stepper: UIStepper!

    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    internal func bind<O>(item: CartItem, quantityStepped: O) where O: ObserverType, O.Element == CartItem {
        thumbnailImageView?.setImageFromS3(path: item.product.imagepath, qos: .userInitiated)
        titleLabel?.text = "\(item.product.name)"
        let productPrice = Constants.Format.price(cents: item.product.price)
        let itemPrice = Constants.Format.price(cents: item.price)
        priceLabel.text = "\(item.quantity) x \(productPrice)\n\(itemPrice)"
        stepper.value = Double(item.quantity)

        stepper.rx.value
            .skip(1)
            .map { stepValue -> CartItem in
                var updated = item
                updated.quantity = Int(stepValue)
                return updated
            }
            .bind(to: quantityStepped)
            .disposed(by: disposeBag)
    }
}
