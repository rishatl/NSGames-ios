//
//  FavoritesService.swift
//  NSGames
//
//  Created by Rishat Latypov on 02.05.2022
//

import Foundation
import Alamofire

class FavoritesService: HomeScreenServiceProtocol {
    func getData(completion: @escaping (Result<[AdCollectionViewCellConfig], AdServiceError>) -> Void) {

        AF.request(AdsRequestPath.favorites,
                   method: .get,
                   parameters: nil,
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
                            let ads = try MyJSONDecoder().decode([AdFeedDto].self, from: data)
                            var configs = [AdCollectionViewCellConfig]()
                            for ad in ads {
                                configs.append(AdCollectionViewCellConfig(id: ad.id, image: ad.photoName, name: ad.name, date: Date(), isLiked: ad.liked))
                            }
                            return completion(.success(configs))
                        } catch {
                            return completion(.failure(.wrongData))
                        }
                    }
        }
    }

    func likeAd(id: Int, completion: @escaping (Result<Void, AdServiceError>) -> Void) {
        AF.request(AdsRequestPath.like,
                   method: .post,
                   parameters: [AdsServicePropertyName.id: id],
                   encoder: JSONParameterEncoder.default,
                   headers: HeaderService.shared.getHeaders()).responseJSON { response in
                    if response.error != nil {
                        return completion(.failure(.noConnection))
                    }
                    if let statusCode = response.response?.statusCode, !(200...300).contains(statusCode) {
                        return completion(.failure(.badRequest))
                    }
                    return completion(.success(()))
        }
    }

    func searchAd(startWith: String, completion: @escaping (Result<[AdCollectionViewCellConfig], AdServiceError>) -> Void) { }
}
