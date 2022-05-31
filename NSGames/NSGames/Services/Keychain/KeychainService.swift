//
//  Keychain.swift
//  NSGames
//
//  Created by Rishat Latypov on 05.04.2022
//

import Foundation
import KeychainAccess

enum KeychainNames {
    static let token = "Token"
    static let chatId = "ChatId"
}

enum KeychainService {
    private static let keychain = Keychain(service: "com.nsgames")

    static func saveToken(_ token: String) {
        keychain[KeychainNames.token] = token
    }

    static func saveChatId(_ id: String) {
        keychain[KeychainNames.chatId] = id
    }

    static func getToken() -> String? {
        keychain[KeychainNames.token]
    }

    static func getChatId() -> String? {
        keychain[KeychainNames.chatId]
    }

    static func deleteAll() {
        keychain[KeychainNames.token] = nil
        keychain[KeychainNames.chatId] = nil
    }
}
