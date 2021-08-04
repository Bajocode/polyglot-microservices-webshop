//
//  ProductTableViewCell.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 11/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

internal final class ProductTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!

    private var bag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        thumbnailImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.clipsToBounds = true
    }

    internal func bind<T>(product: Product, buttonTapped: T) where T: ObserverType, T.Element == Product {
        thumbnailImageView?.setImageFromS3(path: product.imagepath, qos: .userInitiated)
        titleLabel.text = product.name
        priceLabel.text = Constants.Format.price(cents: product.price)

        addButton.rx.tap
            .map { product }
            .bind(to: buttonTapped)
            .disposed(by: bag)
    }
}
