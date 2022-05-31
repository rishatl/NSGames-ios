//
//  MockSignUpService.swift
//  NSGames
//
//  Created by Rishat Latypov on 17.03.2022
//

import Foundation
import Alamofire

class SignUpService: SignUpServiceProtocol {
    func signUp(username: String, email: String, password: String, completion: @escaping (Result<(), SignUpError>) -> Void) {
        let responseBody = [AuthenticationPropertyName.email: email,
                            AuthenticationPropertyName.password: password,
                            AuthenticationPropertyName.username: username]

        AF.request(AuthRequestPath.singUp,
                   method: .post,
                   parameters: responseBody,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
                    if response.error != nil {
                        return completion(.failure(.noConnection))
                    }
                    if response.response?.statusCode == 440 {
                        return completion(.failure(.emailIsOccupied))
                    }
                    if let statusCode = response.response?.statusCode, !(200...300).contains(statusCode) {
                        return completion(.failure(.badRequest))
                    }
                    return completion(.success(()))
        }
    }
}
