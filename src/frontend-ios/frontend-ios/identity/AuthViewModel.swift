//
//  AuthViewModel.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import RxSwift
import RxCocoa
import Moya

protocol AuthViewModelInput {
    var viewWillAppear: Observable<Void> { get }
    var loginButtonTap: Observable<Void> { get }
    var registerButtonTap: Observable<Void> { get }
    var emailTextFieldText: Observable<String> { get }
    var passwordTextFieldText: Observable<String> { get }
}

protocol AuthViewModelOutput {
    var reset: Driver<Void> { get }
    var authorization: Driver<Void> { get }
}

enum AuthError: Int {
    case unauthorized = 401
    case badRequest = 400
    case emailExists = 409

    var message: String {
        switch self {
        case .unauthorized, .badRequest:
            return "Incorrect email or password"
        case .emailExists:
            return "A user with this email already exists"
        }
    }
}

internal struct AuthViewModel {
    typealias Dependencies = IdentityServiceDependency

    let dependencies: Dependencies

    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension AuthViewModel: ReactiveTransforming {
    internal struct Input: AuthViewModelInput {
        let viewWillAppear: Observable<Void>
        let loginButtonTap: Observable<Void>
        let registerButtonTap: Observable<Void>
        let emailTextFieldText: Observable<String>
        let passwordTextFieldText: Observable<String>
    }

    internal struct Output: AuthViewModelOutput {
        let reset: Driver<Void>
        let authorization: Driver<Void>
    }

    internal func transform(_ input: Input) -> Output {
        let reset = input.viewWillAppear.do { _ in
            self.dependencies.identityService.logOut()
        }.asDriver(onErrorJustReturn: ())
        let user = Observable.combineLatest(input.emailTextFieldText, input.passwordTextFieldText)
            .map { User(email: $0.0, password: $0.1) }
        let registration = input.registerButtonTap
            .withLatestFrom(user)
            .flatMapLatest { (user) -> Driver<Void> in
                return MicroserviceClient.execute(AuthRequest.Register(user: user))
                    .do(onSuccess: { token in
                        IdentityService.shared.storeToken(token)
                        Coordinator.shared.transition(to: .root, style: .entry)
                    }, onError: { error in
                        Coordinator.shared.alert(title: "Oops", message: message(for: error))
                    })
                    .map { _ in }
                    .asDriver(onErrorJustReturn: ())
            }.asDriver(onErrorJustReturn: ())
        let login = input.loginButtonTap
            .withLatestFrom(user)
            .flatMapLatest { (user) -> Driver<Void> in
                return MicroserviceClient.execute(AuthRequest.Login(user: user))
                    .do(onSuccess: { token in
                        IdentityService.shared.storeToken(token)
                        Coordinator.shared.transition(to: .root, style: .entry)
                    }, onError: { error in
                        Coordinator.shared.alert(title: "Oops", message: message(for: error))
                     })
                    .map { _ in }
                    .asDriver(onErrorJustReturn: ())
            }.asDriver(onErrorJustReturn: ())
        
        return Output(
            reset: reset,
            authorization: Driver.merge(registration, login)
        )
    }

    private func message(for error: Error) -> String {
        if let httpErr = error as? MoyaError,
           let res = httpErr.response,
           let authErr = AuthError(rawValue: res.statusCode) {
            return authErr.message
        }
        return "Something went wrong, please try again"
    }
}
