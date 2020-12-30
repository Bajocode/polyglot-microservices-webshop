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
        let selection = tableView.rx.itemSelected.asObservable()
        let output = viewModel.transform(ProductsViewModel.Input(
                                            viewWillAppear: vwa,
                                            cellSelection: selection))

        output.products
            .drive(tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self),
                                         cellType: UITableViewCell.self)) { (_, item, cell) in
                cell.textLabel?.text = item.name
            }
            .disposed(by: bag)
        output.productTransition
            .drive()
            .disposed(by: bag)
    }

    private func setup() {
        bind(to: viewModel)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.constrainEdgesToSuper()
        tableView.reloadData()
    }
}
