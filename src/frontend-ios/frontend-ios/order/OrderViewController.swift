//
//  OrderViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 21/11/2020.
//

import RxSwift
import RxCocoa

internal final class OrderViewController: UIViewController {
    private let bag = DisposeBag()
    private let viewModel: OrderViewModel
    private lazy var tableView = UITableView(frame: view.bounds, style: .plain)

    internal override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    internal init(viewModel: OrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(to: OrderViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
        let selection = tableView.rx.itemSelected.asObservable()
        let input = OrderViewModel.Input(viewWillAppear: vwa,
                                         cellSelection: selection)
        let output = viewModel.transform(input)

        output.order
            .do { [weak self] in
                self?.navigationItem.prompt = Constants.Format.dateString(timestamp: $0.created) }
            .map { "Total: \(Constants.Format.price(cents: $0.price))" }
            .drive(navigationItem.rx.title)
            .disposed(by: bag)
        output.order

            .drive()
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
        output.productTransition
            .drive()
            .disposed(by: bag)
    }

    private func setup() {
        bind(to: viewModel)
        view.addSubview(tableView)
        let id = String.init(describing: OrderTableViewCell.self)
        let nib = UINib(nibName: id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: id)
        tableView.constrainEdgesToSuper()
    }
}
