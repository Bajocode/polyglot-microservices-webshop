//
//  CartViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxSwift
import RxCocoa

internal final class CartViewController: UIViewController {
    private let bag = DisposeBag()
    private let viewModel: CartViewModel
    private lazy var tableView = UITableView(frame: view.bounds, style: .plain)
    private var orderButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Order", style: .done, target: nil, action: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        bind(to: viewModel)
        view.addSubview(tableView)
        let id = String.init(describing: CartTableViewCell.self)
        let nib = UINib(nibName: id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: id)
        tableView.rowHeight = 300
        tableView.constrainEdgesToSuper()
        navigationItem.setRightBarButton(orderButton, animated: true)
    }

    private func bind(to: CartViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
        let quantityStep = PublishSubject<CartItem>()
        let orderButtonTap = orderButton.rx.tap.asObservable()
        let selection = tableView.rx.itemSelected.asObservable()
        let input = CartViewModel.Input(viewWillAppear: vwa,
                                        quantityStep: quantityStep,
                                        orderButtonTap: orderButtonTap,
                                        cellSelection: selection)
        let output = viewModel.transform(input)

        output.cart
            .map { $0.items.map { $0.price }.reduce(0, +) } // O(N) move elsewhere for pre-calc
            .map { "Total: \(Constants.Format.price(cents: $0 ))" }
            .drive(navigationItem.rx.title)
            .disposed(by: bag)
        output.cart
            .map { !$0.items.isEmpty }
            .drive(orderButton.rx.isEnabled)
            .disposed(by: bag)
        output.cart
            .map { $0.items }
            .drive(tableView.rx.items(
                        cellIdentifier: String(describing: CartTableViewCell.self),
                        cellType: CartTableViewCell.self)) { (_, item, cell) in
                cell.bind(item: item, quantityStepped: quantityStep.asObserver())}
            .disposed(by: bag)
        output.cartUpdate
            .drive()
            .disposed(by: bag)
        output.orderTransition
            .drive()
            .disposed(by: bag)
        output.productTransition
            .drive()
            .disposed(by: bag)
    }
}
