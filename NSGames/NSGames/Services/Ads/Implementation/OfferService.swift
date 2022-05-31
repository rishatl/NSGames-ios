//
//  MockOfferService.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.03.2022
//

import Foundation
import Alamofire

class OfferService: OfferServiceProtocol {
    func sendOffer(offer: OfferDto, completion: @escaping (Result<Void, AdServiceError>) -> Void) {
        AF.request(AdsRequestPath.offer,
                   method: .post,
                   parameters: offer,
                   encoder: JSONParameterEncoder.default,
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
                    return completion(.success(()))
        }
    }
}
