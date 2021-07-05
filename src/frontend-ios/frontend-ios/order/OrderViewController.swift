//
//  OrderViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 21/11/2020.
//

import RxSwift
import RxCocoa

class OrderViewController: UIViewController {
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
            .map { [weak self] in self?.viewModel.dateString(for: $0) }
            .drive(navigationItem.rx.title)
            .disposed(by: bag)
        output.order
            .map { $0.items }
            .drive(tableView.rx.items(
                    cellIdentifier: String(describing: UITableViewCell.self),
                    cellType: UITableViewCell.self)) { (_, item, cell) in
                cell.textLabel?.text = item.product.name + "  -  " + item.price.description
            }
            .disposed(by: bag)
        output.productTransition
            .drive()
            .disposed(by: bag)
    }

    private func setup() {
        bind(to: viewModel)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String.init(describing: UITableViewCell.self))
        tableView.constrainEdgesToSuper()
    }
}
