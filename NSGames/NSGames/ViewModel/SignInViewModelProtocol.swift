//
//  SignInViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 08.03.2022
//

import Foundation

protocol SignInViewModelProtocol {
    var signInError: ObservableUI<String?> { get set }

    func signIn(email: String, password: String)
    func registration()
    func forgotPassword()
}

class SignInViewModel: SignInViewModelProtocol {

    var signInError: ObservableUI<String?> = ObservableUI(nil)

    private let signInService: SignInServiceProtocol
    private let coordinator: AuthenticationCoordinator

    init(service: SignInServiceProtocol, coordinator: AuthenticationCoordinator) {
        signInService = service
        self.coordinator = coordinator
    }

    // MARK: - SignInViewModel
    func signIn(email: String, password: String) {
        if email.isEmpty && password.isEmpty {
            return signInError.value = "Пожалуйста, заполните данными поля."
        }
        if email.isEmpty {
            return signInError.value = "Введите адрес электронной почты."
        }
        if password.isEmpty {
            return signInError.value = "Введите пароль."
        }
        signInService.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.coordinator.authFinished()

            case .failure(let error):
                switch error {
                case .noConnection:
                    self?.signInError.value = "Нет соединения."
                case .wrongData:
                    self?.signInError.value = "Неверные данные."
                case .badRequest:
                    self?.signInError.value = "Ошибка сервера."
                }
            }
        }
    }

    func registration() {
        coordinator.goToSignUpView()
    }

    func forgotPassword() {
        coordinator.goToForgotPasswordView()
    }
}
