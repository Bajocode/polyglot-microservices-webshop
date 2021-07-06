//
//  ProductTableViewCell.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 11/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class ProductTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!

    private var bag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        thumbnailImageView.clipsToBounds = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind<T>(product: Product, buttonTapped: T) where T: ObserverType, T.Element == Product {
        titleLabel.text = product.name
        priceLabel.text = "$ \(product.price)"

        let modifier = AnyModifier { request in
            var req = request
            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InVzZXJpZCJ9.eyJ1c2VyaWQiOiJjOWI2N2I5OC1iNjQ4LTRkNTEtYTA4Yy0yMzEzYmU0OTRhMTMiLCJ1c2VyIjp7InVzZXJpZCI6ImM5YjY3Yjk4LWI2NDgtNGQ1MS1hMDhjLTIzMTNiZTQ5NGExMyIsImVtYWlsIjoiYUBiLmNvbSJ9LCJpYXQiOjE2MjU2MDM4OTcsImV4cCI6MzI1MTM4MDU5NH0.k48ojF-pLAw9_HmnN5xup_v0ZF5grAmqJi04yjDE7Xo"
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return req
        }
        let url = URL(string: "http://0.0.0.0:8080/media\(product.imagepath)")
        thumbnailImageView.kf.setImage(with: url, placeholder: nil, options: [.requestModifier(modifier)])
        thumbnailImageView.image = nil

        addButton.rx.tap
            .map { product }
            .bind(to: buttonTapped)
            .disposed(by: bag)
    }
}
