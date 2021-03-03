//
//  AuthViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 18/11/2020.
//

import RxSwift
import RxCocoa

internal class AuthViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!

    private let bag = DisposeBag()
    private let viewModel: AuthViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    internal init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(to: AuthViewModel) {
        let vwa = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
        let input = AuthViewModel.Input(
            viewWillAppear: vwa,
            loginButtonTap: loginButton.rx.tap.asObservable(),
            registerButtonTap: registerButton.rx.tap.asObservable(),
            emailTextFieldText: emailTextField.rx.text.orEmpty.asObservable(),
            passwordTextFieldText: passwordTextField.rx.text.orEmpty.asObservable())
        let output = viewModel.transform(input)

        output.reset
            .drive()
            .disposed(by: bag)
        output.authorization
            .drive()
            .disposed(by: bag)
    }

    private func setup() {
        bind(to: viewModel)
    }
}
