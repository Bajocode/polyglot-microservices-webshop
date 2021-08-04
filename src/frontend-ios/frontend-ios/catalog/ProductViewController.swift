//
//  ProductViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 21/11/2020.
//

import RxSwift
import RxCocoa

internal final class ProductViewController: UIViewController {
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var upsertCartButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!

    private let bag = DisposeBag()
    private let viewModel: ProductViewModel

    internal override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    internal init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(to: ProductViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
        let upsertCartButtonTap = upsertCartButton.rx.tap.asDriver()
        let output = viewModel.transform(ProductViewModel.Input(
                                            viewWillAppear: vwa,
                                            upsertCartButtonTap: upsertCartButtonTap))
        output.cartUpdate
            .drive()
            .disposed(by: bag)
    }

    private func setup() {
        bind(to: viewModel)
        imageView.setImageFromS3(path: viewModel.product.imagepath)
        productNameLabel.text = viewModel.product.name
        productPriceLabel.text = Constants.Format.price(cents: viewModel.product.price)
    }
}
