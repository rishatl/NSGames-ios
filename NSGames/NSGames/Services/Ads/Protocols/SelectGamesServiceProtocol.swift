//
//  SelectGamesServiceProtocol.swift
//  NSGames
//
//  Created by Rishat Latypov on 28.03.2022
//

import Foundation

protocol SelectGamesServiceProtocol {
    func getGamesArray(id: Int, completion: @escaping (Result<[Game], AdServiceError>) -> Void)
    func getAllGames(completion: @escaping (Result<[Game], AdServiceError>) -> Void)
    func getTradeGamesArray(id: Int, completion: @escaping (Result<[Game], AdServiceError>) -> Void)
}
