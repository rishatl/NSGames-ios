//
//  ProfileServiceNames.swift
//  NSGames
//
//  Created by Rishat Latypov on 29.04.2022
//

import Foundation

enum ProfileRequestPath {
    static let ads = BaseUrl.host + "/user/ads"
    static let userInfo = BaseUrl.host + "/user/info"
    static let detail = BaseUrl.host + "/ad/offers"
    static let delete = BaseUrl.host + "/ad/delete"
    static let logout = BaseUrl.host + "/user/logout"
}

struct ProfileAdDto: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let date: Date
    let countTradeGames: Int
    let countOffers: Int
    let countViews: Int
    let firstPhoto: String
}

struct DetailOfferDto: Codable {
    let id: Int
    let price: Double?
    let chatId: String
    let name: String
    let description: String
    let countOfTradeList: Int?
}
