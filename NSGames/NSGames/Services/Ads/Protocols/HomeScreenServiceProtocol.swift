//
//  HomeScreenService.swift
//  NSGames
//
//  Created by Rishat Latypov on 15.03.2022
//

import Foundation

protocol HomeScreenServiceProtocol {
    func searchAd(startWith: String, completion: @escaping (Result<[AdCollectionViewCellConfig], AdServiceError>) -> Void)
    func getData(completion: @escaping (Result<[AdCollectionViewCellConfig], AdServiceError>) -> Void)
    func likeAd(id: Int, completion: @escaping (Result<Void, AdServiceError>) -> Void)
}
