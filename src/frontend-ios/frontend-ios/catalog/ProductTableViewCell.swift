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
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with product: Product) {
        titleLabel.text = product.name
        priceLabel.text = "$ \(product.price)"
        
    }

    func bind<T>(item: CartItem, buttonTapped: T) where T: ObserverType, T.Element == Void {
        textLabel?.text = "\(item.product.name) - \(item.price)"

        addButton.rx.tap
            .bind(to: buttonTapped)
            .disposed(by: bag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
