//
//  MockSelectGamesService.swift
//  NSGames
//
//  Created by Rishat Latypov on 28.03.2022
//

import Foundation
import Alamofire

class SelectGamesService: SelectGamesServiceProtocol {
    func getAllGames(completion: @escaping (Result<[Game], AdServiceError>) -> Void) {
        AF.request(AdsRequestPath.allGameList,
                   method: .get,
                   headers: HeaderService.shared.getHeaders()).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
                    if response.error != nil {
                        return completion(.failure(.noConnection))
                    }
                    if let statusCode = response.response?.statusCode {
                        StatusCodeHelper.isForbidden(statusCode: statusCode)
                        if !(200...300).contains(statusCode) {
                            return completion(.failure(.badRequest))
                        }
                    }
                    if let data = response.data {
                        do {
                            let games = try JSONDecoder().decode([GameDto].self, from: data)
                            var result = [Game]()
                            for game in games {
                                result.append(Game(id: game.id, name: game.name))
                            }
                            return completion(.success(result))
                        } catch {
                            return completion(.failure(.wrongData))
                        }
                    }
        }
    }

    func getGamesArray(id: Int, completion: @escaping (Result<[Game], AdServiceError>) -> Void) {
        AF.request(AdsRequestPath.tradeList + "\(id)",
                   method: .get,
                   headers: HeaderService.shared.getHeaders()).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
                    if response.error != nil {
                        return completion(.failure(.noConnection))
                    }
                    if let statusCode = response.response?.statusCode, !(200...300).contains(statusCode) {
                        return completion(.failure(.badRequest))
                    }
                    if let data = response.data {
                        do {
                            let games = try JSONDecoder().decode([GameDto].self, from: data)
                            var result = [Game]()
                            for game in games {
                                result.append(Game(id: game.id, name: game.name))
                            }
                            return completion(.success(result))
                        } catch {
                            return completion(.failure(.wrongData))
                        }
                    }
        }
    }

    func getTradeGamesArray(id: Int, completion: @escaping (Result<[Game], AdServiceError>) -> Void) {
        AF.request(AdsRequestPath.offerTradeList + "\(id)",
                   method: .get,
                   headers: HeaderService.shared.getHeaders()).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
                    if response.error != nil {
                        return completion(.failure(.noConnection))
                    }
                    if let statusCode = response.response?.statusCode, !(200...300).contains(statusCode) {
                        return completion(.failure(.badRequest))
                    }
                    if let data = response.data {
                        do {
                            let games = try JSONDecoder().decode([GameDto].self, from: data)
                            var result = [Game]()
                            for game in games {
                                result.append(Game(id: game.id, name: game.name))
                            }
                            return completion(.success(result))
                        } catch {
                            return completion(.failure(.wrongData))
                        }
                    }
        }
    }
}
