//
//  CreateAdServiceNames.swift
//  NSGames
//
//  Created by Rishat Latypov on 18.04.2022
//

import Foundation

enum CreateAdPath {
    static let createAd = BaseUrl.host + "/ad/create"
    static let uploadPhoto = BaseUrl.host + "/ad/uploadPhoto/"
}

enum CreateAdResponseBodyPropertyName {
    static let games = "games"
    static let photos = "photos"
}

struct AdForm: Encodable {
    let title: String
    let price: Double?
    let description: String
    let games: [Int]?
}
