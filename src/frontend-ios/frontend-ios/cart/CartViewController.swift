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
        tableView.register(TableViewCell.self, forCellReuseIdentifier: String.init(describing: TableViewCell.self))
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
            .map { !$0.items.isEmpty }
            .drive(orderButton.rx.isEnabled)
            .disposed(by: bag)
        output.cart
            .map { $0.items }
            .drive(tableView.rx.items(
                        cellIdentifier: String(describing: TableViewCell.self),
                        cellType: TableViewCell.self)) { (_, item, cell) in
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

class TableViewCell: UITableViewCell {
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.backgroundColor = .red
        return stepper
    }()
    private var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        stepper.center = center
        contentView.addSubview(stepper)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind<O>(item: CartItem, quantityStepped: O) where O: ObserverType, O.Element == CartItem {
        textLabel?.text = "\(item.product.name) - \(item.price)"
        stepper.value = Double(item.quantity)
        stepper.rx.value
            .skip(1)
            .map { stepValue -> CartItem in
                var updated = item
                updated.quantity = Int(stepValue)
                return updated
            }
            .bind(to: quantityStepped)
            .disposed(by: disposeBag)
    }
}
