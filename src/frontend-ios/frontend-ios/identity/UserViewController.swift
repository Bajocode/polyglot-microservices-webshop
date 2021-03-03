//
//  UserViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 12/12/2020.
//

import RxSwift
import RxCocoa

final class UserViewController: UIViewController {
    private let bag = DisposeBag()
    private let viewModel: UserViewModel
    private lazy var tableView = UITableView(frame: view.bounds, style: .plain)
    private var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        bind(to: viewModel)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String.init(describing: UITableViewCell.self))
        tableView.constrainEdgesToSuper()
        navigationItem.setRightBarButton(logoutButton, animated: true)
    }

    private func bind(to: UserViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
        let selection = tableView.rx.itemSelected.asObservable()
        let logoutButtonTap = logoutButton.rx.tap.asObservable()
        let input = UserViewModel.Input(
            viewWillAppear: vwa,
            cellSelection: selection,
            logoutButtonTap: logoutButtonTap)
        let output = viewModel.transform(input)

        output.orders
            .drive(tableView.rx.items(
                        cellIdentifier: String(describing: UITableViewCell.self),
                        cellType: UITableViewCell.self)) { (_, item, cell) in
                cell.textLabel?.text = item.orderid
            }
            .disposed(by: bag)
        output.orderTransition
            .drive()
            .disposed(by: bag)
        output.userLogout
            .drive()
            .disposed(by: bag)
    }
}
