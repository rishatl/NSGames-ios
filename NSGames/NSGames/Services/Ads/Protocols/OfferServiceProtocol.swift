//
//  OfferService.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.03.2022
//

import Foundation

protocol OfferServiceProtocol {
    func sendOffer(offer: OfferDto, completion: @escaping (Result<Void, AdServiceError>) -> Void)
}
