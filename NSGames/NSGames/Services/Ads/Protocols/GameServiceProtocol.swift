//
//  GameService.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.03.2022
//

import UIKit

protocol GameServiceProtocol {
    func getStringData(id: Int, completion: @escaping (Result<GameSreenConfig, AdServiceError>) -> Void)
}
