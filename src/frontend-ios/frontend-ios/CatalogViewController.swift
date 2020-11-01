//
//  CatalogViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxSwift
import RxCocoa

final class CatalogViewController: UIViewController {
    private let bag = DisposeBag()
    private let viewModel: CatalogViewModel
    private lazy var tableView = UITableView(frame: view.bounds, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        setupView()
    }

    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(to: CatalogViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
            .asObservable()
        let input = CatalogViewModel.Input(viewWillAppear: vwa)
        let output = viewModel.transform(input)

        output.products
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self),
                                         cellType: UITableViewCell.self)) { (_, product, cell) in
                cell.textLabel?.text = product.name
            }
            .disposed(by: bag)

        self.viewModel.cartService.fetch()

        tableView.rx.itemSelected.asObservable().subscribe { [weak self] _ in
            self?.viewModel.cartService.insert(CartItem(productId: "tss", quantity: 3, price: 2))
        }
        .disposed(by: bag)

    }

    private func setupView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.constrainEdgesToSuper()
    }
}
