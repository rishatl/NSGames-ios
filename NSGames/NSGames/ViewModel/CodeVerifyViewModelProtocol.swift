//
//  CodeVerifyViewModel.swift
//  NSGames
//
//  Created by Rishat Latypov on 10.03.2022
//

import Foundation

protocol CodeVerifyViewModelProtocol {
    var email: String { get set }
    var codeVerifyError: ObservableUI<String?> { get set }

    func checkCode(code: String, password: String)
}

class CodeVerifyViewModel: CodeVerifyViewModelProtocol {

    var email: String
    var codeVerifyError: ObservableUI<String?> = ObservableUI(nil)

    private let coordinator: AuthenticationCoordinator
    private let codeVerifyService: CodeVerifyServiceProtocol

    init(service: CodeVerifyServiceProtocol, coordinator: AuthenticationCoordinator, email: String) {
        self.codeVerifyService = service
        self.coordinator = coordinator
        self.email = email
    }

    // MARK: - CodeVerifyViewModel
    func checkCode(code: String, password: String) {
        if code.isEmpty {
            return codeVerifyError.value = "Пожалуйста, введите код"
        }
        codeVerifyService.checkCode(password: password, email: email, code: code) { [weak self] result in
            switch result {
            case .success:
                self?.coordinator.authFinished()

            case .failure(let error):
                switch error {
                case .noConnection:
                    self?.codeVerifyError.value = "Нет соединения."

                case .codeNotCorrect:
                    self?.codeVerifyError.value = "Код введен некорректно."

                case .badRequest:
                    self?.codeVerifyError.value = "Ошибка сервера."
                }
            }
        }
    }
}
