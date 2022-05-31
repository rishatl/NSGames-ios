//
//  SignUpViewModel.swift
//  NSGames
//
//  Created by Rishat Latypov on 09.03.2022
//

import Foundation

protocol SignUpViewModelProtocol {
    var signUpError: ObservableUI<String?> { get set }

    func signUp(login: String, email: String, password: String, passwordAgain: String)
}

class SignUpViewModel: SignUpViewModelProtocol {

    private let signUpService: SignUpServiceProtocol
    private let coordinator: AuthenticationCoordinator

    init(service: SignUpServiceProtocol, coordinator: AuthenticationCoordinator) {
        signUpService = service
        self.coordinator = coordinator
    }

    var signUpError: ObservableUI<String?> = ObservableUI(nil)

    // MARK: - SignInViewModel
    func signUp(login: String, email: String, password: String, passwordAgain: String) {
        if email.isEmpty && login.isEmpty && password.isEmpty && passwordAgain.isEmpty {
            return signUpError.value = L10n.needToField
        }
        if login.isEmpty {
            return signUpError.value = L10n.needToEnterLogin
        }
        if email.isEmpty {
            return signUpError.value = L10n.needToEnterEmail
        }
        if password.isEmpty {
            return signUpError.value = L10n.needToEnterPassword
        }
        if passwordAgain.isEmpty {
            return signUpError.value = L10n.needToRepeatPassword
        }
        if password != passwordAgain {
            return signUpError.value = L10n.passwordIsNotEqual
        }
        signUpService.signUp(username: login, email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.coordinator.popView()

            case .failure(let error):
                switch error {
                case .noConnection:
                    self?.signUpError.value = L10n.inetError

                case .emailIsOccupied:
                    self?.signUpError.value = L10n.emailIsNotFree

                case .badRequest:
                    self?.signUpError.value = L10n.serverError
                }
            }
        }
    }
}
