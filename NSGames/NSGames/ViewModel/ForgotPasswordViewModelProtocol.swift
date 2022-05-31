//
//  ForgotPasswordViewModel.swift
//  NSGames
//
//  Created by Rishat Latypov on 17.03.2022
//

import Foundation

protocol ForgotPasswordViewModelProtocol {
    var emailError: ObservableUI<String?> { get set }

    func checkEmail(email: String)
}

class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {

    var emailError: ObservableUI<String?> = ObservableUI(nil)

    private let forgotPasswordService: ForgotPasswordServiceProtocol
    private let coordinator: AuthenticationCoordinator

    init(service: ForgotPasswordServiceProtocol, coordinator: AuthenticationCoordinator) {
        forgotPasswordService = service
        self.coordinator = coordinator
    }

    func checkEmail(email: String) {
        if email.isEmpty {
            emailError.value = "Введите данные."
        } else {
            forgotPasswordService.checkEmail(email: email) { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator.goToCodeVerifyView(email: email)

                case .failure(let error):
                    switch error {
                    case .wrongEmail:
                        self?.emailError.value = "Пользователя не существует."
                    case .noConnection:
                        self?.emailError.value = "Нет подключения."
                    case .badRequest:
                        self?.emailError.value = "Ошибка сервера."
                    }
                }
            }
        }
    }
}
