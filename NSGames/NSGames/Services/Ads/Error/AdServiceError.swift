//
//  AdServiceError.swift
//  NSGames
//
//  Created by Rishat Latypov on 25.04.2022
//

import Foundation

enum AdServiceError: Error {
    case noConnection
    case badRequest
    case notEncodable
    case wrongData
}
