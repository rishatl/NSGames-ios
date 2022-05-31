//
//  ProfileError.swift
//  NSGames
//
//  Created by Rishat Latypov on 29.04.2022
//

import Foundation

enum ProfileServiceError: Error {
    case noConnection
    case badRequest
    case notEncodable
    case wrongData
}
