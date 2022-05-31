//
//  DetailOfferViewServiceProtocol.swift
//  NSGames
//
//  Created by Rishat Latypov on 09.04.2022
//

import Foundation

protocol DetailOfferViewServiceProtocol {
    func getOffers(id: Int, completion: @escaping (Result<[Offer], AdServiceError>) -> Void)
}
