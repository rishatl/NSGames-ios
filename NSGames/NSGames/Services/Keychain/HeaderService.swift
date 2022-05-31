//
//  HeaderService.swift
//  NSGames
//
//  Created by Rishat Latypov on 25.04.2022
//

import Foundation
import Alamofire

class HeaderService {
    static let shared = HeaderService()

    private init() { }

    func getHeaders() -> HTTPHeaders {
        guard let token = KeychainService.getToken() else { return HTTPHeaders() }

        let headersData: [String: String] = ["Authorization": token]
        return HTTPHeaders(headersData)
    }
}
