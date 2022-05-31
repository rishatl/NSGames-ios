//
//  HomeScreenService.swift
//  NSGames
//
//  Created by Rishat Latypov on 15.03.2022
//

import Foundation
import Alamofire

class HomeScreenService: HomeScreenServiceProtocol {
    func getData(completion: @escaping (Result<[AdCollectionViewCellConfig], AdServiceError>) -> Void) {

        AF.request(AdsRequestPath.feed,
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
                                configs.append(AdCollectionViewCellConfig(id: ad.id, image: ad.photoName, name: ad.name, date: ad.date, isLiked: ad.liked))
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
                   parameters: ["id": id],
                   encoder: JSONParameterEncoder.default,
                   headers: HeaderService.shared.getHeaders()).responseJSON { response in
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

    func searchAd(startWith name: String, completion: @escaping (Result<[AdCollectionViewCellConfig], AdServiceError>) -> Void) {
        AF.request(AdsRequestPath.search + name,
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
                                configs.append(AdCollectionViewCellConfig(id: ad.id, image: ad.photoName, name: ad.name, date: ad.date, isLiked: ad.liked))
                            }
                            return completion(.success(configs))
                        } catch {
                            return completion(.failure(.wrongData))
                        }
                    }
        }
    }
}
