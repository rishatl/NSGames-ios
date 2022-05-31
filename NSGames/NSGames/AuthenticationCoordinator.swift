//
//  AuthenticationCoordinator.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.03.2022
//

import UIKit

class AuthenticationCoordinator: Coordinator {
    let navigationController = UINavigationController()
    var mainCoordinator: MainCoordinator?

    init() {
        let controller = SignInViewController()
        controller.viewModel = SignInViewModel(service: SignInService(),
                                               coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }

    func getStartViewController() -> UIViewController {
        return navigationController
    }

    func goToSignUpView() {
        let controller = SignUpViewController()
        controller.viewModel = SignUpViewModel(service: SignUpService(),
                                               coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }

    func goToForgotPasswordView() {
        let controller = ForgotPasswordViewController()
        controller.viewModel = ForgotPasswordViewModel(service: ForgotPassword(),
                                                       coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }

    func goToCodeVerifyView(email: String) {
        let nextController = CodeVerifyViewController()
        nextController.viewModel = CodeVerifyViewModel(service: CodeVerifyService(),
                                                       coordinator: self, email: email)
        navigationController.pushViewController(nextController, animated: true)
    }

    func popView() {
        navigationController.popViewController(animated: true)
    }

    func authFinished() {
        mainCoordinator?.goToTabBar()
    }
}
