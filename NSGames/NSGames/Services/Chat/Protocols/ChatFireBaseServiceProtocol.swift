//
//  ChatFireBaseServiceProtocol.swift
//  NSGames
//
//  Created by Rishat Latypov on 26.03.2022
//

import Foundation

protocol ChatFireBaseServiceProtocol {
    func sendMessage(myId: String, to otherUserId: String, message: Message, completion: @escaping (Bool) -> Void)
    func setListeners(myId: String, to chatId: String, completion: @escaping (Result<[Message], Error>) -> Void)
}
