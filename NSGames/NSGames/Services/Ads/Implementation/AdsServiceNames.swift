//
//  AdsServiceNames.swift
//  NSGames
//
//  Created by Rishat Latypov on 25.04.2022
//

import Foundation

enum AdsRequestPath {
    static let feed = BaseUrl.host + "/ad/feed"
    static let like = BaseUrl.host + "/ad/like"
    static let detail = BaseUrl.host + "/ad/detail"
    static let search = BaseUrl.host + "/ad/search/"
    static let tradeList = BaseUrl.host + "/ad/tradeList/"
    static let offerTradeList = BaseUrl.host + "/ad/offerGameList/"
    static let allGameList = BaseUrl.host + "/game/getAll"
    static let favorites = BaseUrl.host + "/ad/favorites"
    static let offer = BaseUrl.host + "/ad/createOffer"
}

enum AdsServicePropertyName {
    static let id = "id"
}

struct AdFeedDto: Codable {
    let id: Int
    let liked: Bool
    let name: String
    let date: Date
    let photoName: String
}

struct AdDetailDto: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let date: Date
    let username: String
    let chatId: String
    let countTradeGames: Int
    let countViews: Int
    let photoNames: [String]
}

struct GameDto: Codable {
    let id: Int
    let name: String
}

struct OfferDto: Codable {
    let adId: Int
    let price: Double?
    let tradeList: [Int]
    let description: String
}
