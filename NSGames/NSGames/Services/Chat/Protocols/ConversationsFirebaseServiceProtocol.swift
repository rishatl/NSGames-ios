//
//  FirebaseServiceProtocol.swift
//  NSGames
//
//  Created by Rishat Latypov on 25.03.2022
//

import Foundation

protocol ConversationsFirebaseServiceProtocol {
    func setListeners(to myId: String, completion: @escaping (Result<[Conversation], Error>) -> Void)
}
