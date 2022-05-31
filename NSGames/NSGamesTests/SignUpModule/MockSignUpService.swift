//
//  MockSignUpService.swift
//  NSGamesTests
//
//  Created by Rishat Latypov on 21.05.2022
//

import Foundation
@testable import NSGames

class MockSignUpService: SignUpServiceProtocol {
    func signUp(username: String, email: String, password: String, completion: @escaping (Result<(), SignUpError>) -> Void) {
        return completion(.success(()))
    }
}
