//
//  OrderConfirmViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 24/11/2020.
//

import RxSwift
import RxCocoa

class OrderConfirmViewController: UIViewController {
    private let bag = DisposeBag()
    private let viewModel: OrderConfirmViewModel
    private lazy var tableView = UITableView(frame: view.bounds, style: .plain)
    private var confirmButton: UIBarButtonItem = {
        let buttom = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        buttom.title = "Order"
        return buttom
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String.init(describing: UITableViewCell.self))
        tableView.constrainEdgesToSuper()
        navigationItem.setRightBarButton(confirmButton, animated: true)
    }

    private func bind(to: OrderConfirmViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
        let confirmButtonTap = confirmButton.rx.tap.asObservable()
        let input = OrderConfirmViewModel.Input(viewWillAppear: vwa, confirmButtonTap: confirmButtonTap)
        let output = viewModel.transform(input)

        output.order
            .map { $0.items }
            .drive(tableView.rx.items(
                        cellIdentifier: String(describing: UITableViewCell.self),
                        cellType: UITableViewCell.self)) { (_, item, cell) in
                cell.textLabel?.text = item.product.name + " - " + item.price.description
        }
        .disposed(by: bag)
        output.orderPost
            .drive()
            .disposed(by: bag)
    }
}
