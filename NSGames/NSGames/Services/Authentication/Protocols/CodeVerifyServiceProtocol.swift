//
//  CodeVerifyService.swift
//  NSGames
//
//  Created by Rishat Latypov on 10.03.2022
//

import Foundation

protocol CodeVerifyServiceProtocol {
    func checkCode(password: String, email: String, code: String, completion: @escaping (Result<(), CodeVerifyError>) -> Void)
}
