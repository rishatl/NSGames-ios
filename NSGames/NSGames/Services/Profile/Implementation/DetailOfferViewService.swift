//
//  DetailOfferViewService.swift
//  NSGames
//
//  Created by Rishat Latypov on 09.04.2022
//

import Foundation
import Alamofire

class DetailOfferViewService: DetailOfferViewServiceProtocol {
    func getOffers(id: Int, completion: @escaping (Result<[Offer], AdServiceError>) -> Void) {
        AF.request(ProfileRequestPath.detail + "/\(id)",
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
                            let offers = try JSONDecoder().decode([DetailOfferDto].self, from: data)
                            var configs = [Offer]()
                            for offer in offers {
                                configs.append(Offer(id: offer.id,
                                                     username: offer.name,
                                                     price: offer.price,
                                                     tradeListCount: offer.countOfTradeList,
                                                     description: offer.description,
                                                     chatId: offer.chatId))
                            }
                            return completion(.success(configs))
                        } catch {
                            return completion(.failure(.wrongData))
                        }
                    }
        }
    }
}
