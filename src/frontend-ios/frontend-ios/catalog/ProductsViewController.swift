//
//  ProductsViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxSwift
import RxCocoa

final class ProductsViewController: UIViewController {
    private let bag = DisposeBag()
    private let viewModel: ProductsViewModel
    private lazy var tableView = UITableView(frame: view.bounds, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    init(viewModel: ProductsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(to: ProductsViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
        let addButtonTap = PublishSubject<Void>()
        let selection = tableView.rx.itemSelected.asObservable()
        let output = viewModel.transform(ProductsViewModel.Input(
                                            viewWillAppear: vwa,
                                            addButtonTap: addButtonTap,
                                            cellSelection: selection))

        output.products
            .drive(tableView.rx.items(cellIdentifier: String(describing: ProductTableViewCell.self),
                                         cellType: ProductTableViewCell.self)) { (_, product, cell) in
                var cartItem = CartItem.empty()
                cartItem.product = product

                cell.bind(item: cartItem, buttonTapped: quantityStep.asObserver())
            }
            .disposed(by: bag)
        output.productTransition
            .drive()
            .disposed(by: bag)
    }

    private func setup() {
        bind(to: viewModel)
        view.addSubview(tableView)
        tableView.register(UINib(
                            nibName: String(describing: ProductTableViewCell.self),
                            bundle: Bundle.main),
                           forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
        tableView.constrainEdgesToSuper()
        tableView.reloadData()
    }
}
