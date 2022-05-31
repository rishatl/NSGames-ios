//
//  SignUp.swift
//  NSGames
//
//  Created by Rishat Latypov on 09.03.2022
//

import Foundation

protocol SignUpServiceProtocol {
    func signUp(username: String, email: String, password: String, completion: @escaping (Result<(), SignUpError>) -> Void)
}
