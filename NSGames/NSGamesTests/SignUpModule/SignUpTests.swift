//
//  SignInTests.swift
//  NSGamesTests
//
//  Created by Rishat Latypov on 21.05.2022
//

import XCTest
@testable import NSGames

class SignInTests: XCTestCase {

    var service: SignUpServiceProtocol!
    var viewModel: SignUpViewModelProtocol!

    var email = ""
    var login = ""
    var password = ""
    var passwordAgain = ""

    var resultString: String?

    override func setUpWithError() throws {
        let coordinator = AuthenticationCoordinator()

        service = MockSignUpService()
        viewModel = SignUpViewModel(service: service, coordinator: coordinator)
        viewModel.signUpError.bind { [weak self] text in
            self?.resultString = text
        }
    }

    override func tearDownWithError() throws {
        email = ""
        login = ""
        password = ""
        passwordAgain = ""
    }

    func testAllFealdsIsEmpty() {
        viewModel.signUp(login: login, email: email, password: password, passwordAgain: passwordAgain)

        XCTAssertEqual(resultString, "Пожалуйста, заполните данными поля.")
    }

    func testPasswordNeedToBeEqual() {
        login = "Nikita"
        email = "nikita@gmail.com"
        password = "qwerty"
        passwordAgain = "qwerty123"

        viewModel.signUp(login: login, email: email, password: password, passwordAgain: passwordAgain)

        XCTAssertNotNil(resultString, "Found nil")
        XCTAssertEqual(resultString, "Пароли не совпадают.")
    }

    func testPasswordsIsEqual() {
        login = "Nikita"
        email = "nikita@gmail.com"
        password = "qwerty"
        passwordAgain = "qwerty"

        viewModel.signUp(login: login, email: email, password: password, passwordAgain: passwordAgain)

        XCTAssertNil(resultString)
    }

    func testEmailIsEmpty() {
        login = "Nikita"
        password = "qwerty"
        passwordAgain = "qwerty"

        viewModel.signUp(login: login, email: email, password: password, passwordAgain: passwordAgain)

        XCTAssertNotNil(resultString)
        XCTAssertEqual(resultString, "Введите адрес электронной почты.")
    }

    func testLoginIsEmpty() {
        email = "nikita@gmail.com"
        password = "qwerty"
        passwordAgain = "qwerty"

        viewModel.signUp(login: login, email: email, password: password, passwordAgain: passwordAgain)

        XCTAssertNotNil(resultString)
        XCTAssertEqual(resultString, "Введите логин.")
    }

    func testPasswordIsEmpty() {
        login = "Nikita"
        email = "nikita@gmail.com"
        passwordAgain = "qwerty"

        viewModel.signUp(login: login, email: email, password: password, passwordAgain: passwordAgain)

        XCTAssertNotNil(resultString)
        XCTAssertEqual(resultString, "Введите пароль.")
    }
}
