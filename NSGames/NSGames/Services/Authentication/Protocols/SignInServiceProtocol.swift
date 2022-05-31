//
//  SignInService.swift
//  NSGames
//
//  Created by Rishat Latypov on 08.03.2022
//

import Foundation

protocol SignInServiceProtocol {
    func signIn(email: String, password: String, completion: @escaping (Result<(), SignInError>) -> Void)
}
