//
//  CreateAdServiceProtocol.swift
//  NSGames
//
//  Created by Rishat Latypov on 18.04.2022
//

import Foundation

protocol CreateAdServiceProtocol {
    func uploadAd(images: [Data], ad: AdForm, completion: @escaping (Result<(), CreateAdError>) -> Void)
}
