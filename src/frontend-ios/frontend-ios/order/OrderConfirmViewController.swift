//
//  OrderConfirmViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 24/11/2020.
//

import RxSwift
import RxCocoa

internal final class OrderConfirmViewController: UIViewController {
    private let bag = DisposeBag()
    private let viewModel: OrderConfirmViewModel
    private lazy var tableView = UITableView(frame: view.bounds, style: .plain)
    private var confirmButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Buy", style: .done, target: nil, action: nil)
    }()
    private var cancelButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    }()

    internal override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    internal init(viewModel: OrderConfirmViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        bind(to: viewModel)
        view.addSubview(tableView)
        let id = String.init(describing: OrderTableViewCell.self)
        let nib = UINib(nibName: id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: id)
        tableView.constrainEdgesToSuper()
        navigationItem.setRightBarButton(confirmButton, animated: false)
        navigationItem.setLeftBarButton(cancelButton, animated: false)
    }

    private func bind(to: OrderConfirmViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
        let confirmButtonTap = confirmButton.rx.tap.asObservable()
        let cancelButtonTap = cancelButton.rx.tap.asObservable()
        let input = OrderConfirmViewModel.Input(viewWillAppear: vwa,
                                                confirmButtonTap: confirmButtonTap,
                                                cancelButtonTap: cancelButtonTap)
        let output = viewModel.transform(input)

        output.order
            .map { $0.items.map { $0.price }.reduce(0, +) } // O(N) move elsewhere for pre-calc
            .map { "Total: \(Constants.Format.price(cents: $0 ))" }
            .drive(navigationItem.rx.title)
            .disposed(by: bag)
        output.order
            .map { $0.items }
            .drive(tableView.rx.items(
                        cellIdentifier: String(describing: OrderTableViewCell.self),
                        cellType: OrderTableViewCell.self)) { (_, item, cell) in
                cell.textLabel?.text = item.product.name
                let productPrice = Constants.Format.price(cents: item.product.price)
                let itemPrice = Constants.Format.price(cents: item.price)
                cell.detailTextLabel?.text = "\(item.quantity) x \(productPrice)) (\(itemPrice))"
        }
        .disposed(by: bag)
        output.orderPost
            .drive()
            .disposed(by: bag)
        output.orderCancel
            .drive()
            .disposed(by: bag)
    }
}
