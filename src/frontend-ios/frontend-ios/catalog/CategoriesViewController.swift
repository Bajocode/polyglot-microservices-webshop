//
//  CategoriesViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxSwift
import RxCocoa

final internal class CategoriesViewController: UIViewController {
    private let bag = DisposeBag()
    private let viewModel: CategoriesViewModel
    private lazy var tableView = UITableView(frame: view.bounds, style: .plain)

    internal override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    internal init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(to: CategoriesViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        let selection = tableView.rx.itemSelected
            .asDriver()
        let output = viewModel.transform(CategoriesViewModel.Input(
                                            viewWillAppear: vwa,
                                            cellSelection: selection))

        output.categories
            .drive(tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self),
                                         cellType: UITableViewCell.self)) { (_, item, cell) in
                cell.textLabel?.text = item.name
            }
            .disposed(by: bag)
        output.categoriesOrProductsTransition
            .drive()
            .disposed(by: bag)
    }

    private func setup() {
        bind(to: viewModel)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.constrainEdgesToSuper()
    }
}
