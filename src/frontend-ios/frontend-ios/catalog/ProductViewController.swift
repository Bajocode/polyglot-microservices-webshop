//
//  ProductViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 21/11/2020.
//

import RxSwift
import RxCocoa

class ProductViewController: UIViewController {
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var upsertCartButton: UIButton!

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
        let upsertCartButtonTap = upsertCartButton.rx.tap.asDriver()
        let output = viewModel.transform(ProductViewModel.Input(upsertCartButtonTap: upsertCartButtonTap))

        output.cartUpdate
            .drive()
            .disposed(by: bag)
    }

    private func setup() {
        bind(to: viewModel)
        productNameLabel.text = viewModel.product.name
        productPriceLabel.text = "\(viewModel.product.price)"
    }
}
