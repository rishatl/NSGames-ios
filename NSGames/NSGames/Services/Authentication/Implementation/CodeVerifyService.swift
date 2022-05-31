//
//  RestCodeVerifyService.swift
//  NSGames
//
//  Created by Rishat Latypov on 17.03.2022
//

import Foundation
import Alamofire

class CodeVerifyService: CodeVerifyServiceProtocol {
    func checkCode(password: String, email: String, code: String, completion: @escaping (Result<(), CodeVerifyError>) -> Void) {

        let responseBody = [AuthenticationPropertyName.email: email,
                            AuthenticationPropertyName.code: code,
                            AuthenticationPropertyName.password: password]

        DispatchQueue.global().async {
            AF.request(AuthRequestPath.changePassword,
                       method: .post,
                       parameters: responseBody,
                       encoder: JSONParameterEncoder.default).response { response in
                        if response.error != nil {
                            return completion(.failure(.noConnection))
                        }
                        if response.response?.statusCode == 440 {
                            return completion(.failure(.codeNotCorrect))
                        }
                        if let statusCode = response.response?.statusCode, !(200...300).contains(statusCode) {
                            return completion(.failure(.badRequest))
                        }
                        if let data = response.data {
                            do {
                                let data = try JSONDecoder().decode(SignInResponse.self, from: data)
                                KeychainService.saveToken(data.token)
                                KeychainService.saveChatId(data.user.chatId)
                                return completion(.success(()))
                            } catch {
                                return completion(.failure(.codeNotCorrect))
                            }
                        }
            }
        }
    }
}
