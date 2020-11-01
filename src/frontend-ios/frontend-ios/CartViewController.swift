//
//  CartViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxSwift
import RxCocoa

final class CartViewController: UIViewController {
    private let bag = DisposeBag()
    private let viewModel = CartViewModel()
    private lazy var tableView = UITableView(frame: view.bounds, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        setupView()
    }

    private func bind(to: CartViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
            .asObservable()
        let input = CartViewModel.Input(viewWillAppear: vwa)
        let output = viewModel.transform(input)
        let cartItems = output.cart.map({ cart in cart.cartItems })

        cartItems.bind(to: tableView.rx.items(
                        cellIdentifier: String(describing: UITableViewCell.self),
                        cellType: UITableViewCell.self)) { (_, cartItem, cell) in
            cell.textLabel?.text = cartItem.productId
        }
        .disposed(by: bag)
    }

    private func setupView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.constrainEdgesToSuper()
    }
}
