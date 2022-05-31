//
//  ProfileViewService.swift
//  NSGames
//
//  Created by Rishat Latypov on 09.04.2022
//

import Foundation
import Alamofire
import Kingfisher

class ProfileViewService: ProfileViewServiceProtocol {
    var configs = [AdWrapper]()
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "saveImageQueue")

    func getUserInfo(completion: @escaping (Result<UserInfo, ProfileServiceError>) -> Void) {
        AF.request(ProfileRequestPath.userInfo,
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
                            let userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
                            return completion(.success(userInfo))
                        } catch {
                            return completion(.failure(.wrongData))
                        }
                    }
        }
    }

    func getAds(completion: @escaping (Result<[AdTableViewCellConfig], ProfileServiceError>) -> Void) {
        configs = [AdWrapper]()
        AF.request(ProfileRequestPath.ads,
                   method: .get,
                   parameters: nil,
                   headers: HeaderService.shared.getHeaders()).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { [unowned self] response in
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
                            let ads = try MyJSONDecoder().decode([ProfileAdDto].self, from: data)
                            loadAds(ads: ads)
                            group.wait()
                            return completion(.success(self.configs.sorted().map { $0.ad }))
                        } catch {
                            return completion(.failure(.wrongData))
                        }
                    }
        }
    }

    func deleteAd(id: Int, completion: @escaping (Result<Void, ProfileServiceError>) -> Void) {
        AF.request(ProfileRequestPath.delete + "/\(id)",
                   method: .delete,
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

    func logout(completion: @escaping (Result<Void, ProfileServiceError>) -> Void) {
        AF.request(ProfileRequestPath.logout,
                   method: .post,
                   headers: HeaderService.shared.getHeaders()).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
                    if response.error != nil {
                        if !response.error!.isResponseSerializationError {
                            return completion(.failure(.noConnection))
                        }
                    }
                    if let statusCode = response.response?.statusCode {
                        StatusCodeHelper.isForbidden(statusCode: statusCode)
                        if !(200...300).contains(statusCode) {
                            return completion(.failure(.badRequest))
                        }
                    }
                    DispatchQueue.main.async {
                        return completion(.success(()))
                    }
        }
    }

    private func loadAds(ads: [ProfileAdDto]) {
        for ad in ads.enumerated() {
            guard let url = URL(string: BaseUrl.kingFisherHostImageUrl + ad.element.firstPhoto) else { break }
            group.enter()
            KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let image):
                    if let imageData = image.image.pngData() {
                        self.queue.async {
                            self.configs.append(AdWrapper(ad: AdTableViewCellConfig(id: ad.element.id,
                                                                                    name: ad.element.title,
                                                                                    numberOfOffers: ad.element.countOffers,
                                                                                    photo: imageData,
                                                                                    views: ad.element.countViews),
                                                     index: ad.offset))
                            self.group.leave()
                        }
                    }

                case .failure:
                    self.group.leave()
                }
            }
        }
    }
}
