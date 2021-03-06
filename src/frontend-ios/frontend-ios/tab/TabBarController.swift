//
//  TabBarController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 23/11/2020.
//

import RxSwift
import RxCocoa

class TabBarController: UITabBarController {
    private let bag = DisposeBag()
    private let viewModel: TabBarViewModel

    init(viewModel: TabBarViewModel, vcs: [UIViewController]) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = vcs
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        bind(to: viewModel)
        self.tabBar.items![0].title = "Catalog"
        self.tabBar.items![1].title = "Cart"
        self.tabBar.items![2].title = "User"
    }

    private func bind(to: TabBarViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
        let tabSelect = rx.didSelect.asObservable()
        let input = TabBarViewModel.Input(viewWillAppear: vwa, tabSelect: tabSelect)
        let output = viewModel.transform(input)

        output.cartSync
            .drive()
            .disposed(by: bag)
        output.sharedCart
            .map { "\($0.items.count)" }
            .drive( self.tabBar.items![1].rx.badgeValue )
            .disposed(by: bag)
        output.coordinatorSync
            .drive()
            .disposed(by: bag)
    }
}
