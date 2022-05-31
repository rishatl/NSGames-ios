//
//  AdDto.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.04.2022
//

import Foundation

struct AdDto: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let date: Date
    let username: String
    let chatId: String
    let countTradeGames: Int
    let countViews: Int
}

struct AdId: Codable {
    let id: Int
}
