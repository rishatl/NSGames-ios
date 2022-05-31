//
//  ForgotPasswordService.swift
//  NSGames
//
//  Created by Rishat Latypov on 17.03.2022
//

import Foundation

protocol ForgotPasswordServiceProtocol {
    func checkEmail(email: String, completion: @escaping (Result<(), ForgotPasswordError>) -> Void)
}
