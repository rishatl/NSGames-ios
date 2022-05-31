//
//  ChatViewModelProtocol.swift
//  NSGames
//
//  Created by Rishat Latypov on 26.03.2022
//

import Foundation

protocol ChatViewModelProtocol {
    var title: Observable<String> { get set }
    var error: Observable<String?> { get set }
    var items: Observable<[Message]> { get set }

    func sendMessage(text content: String)
    func setup()
}

class ChatViewModel: ChatViewModelProtocol {
    var title: Observable<String> = Observable("")
    var error: Observable<String?> = Observable(nil)
    var items: Observable<[Message]> = Observable([])

    let myId = KeychainService.getChatId()
    private let service: ChatFireBaseServiceProtocol
    private let otherUserId: String
    private let titleString: String

    init(service: ChatFireBaseServiceProtocol, id: String, title: String) {
        self.service = service
        otherUserId = id
        self.titleString = title
    }

    func setup() {
        self.title.value = titleString
        if let myId = myId {
            service.setListeners(myId: myId, to: otherUserId) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.error.value = L10n.inetError + error.localizedDescription

                case .success(let array):
                    DispatchQueue.main.async {
                        self?.items.value = array
                    }
                }
            }
        } else {
            error.value = InetErrorNames.localData
        }
    }

    func sendMessage(text content: String) {
        if let myId = myId {
            let message = Message(content: content, created: Date(), senderId: myId)
            service.sendMessage(myId: myId, to: otherUserId, message: message) { [weak self] flag in
                if flag == false {
                    self?.error.value = InetErrorNames.failedConnection
                }
            }
        }
    }
}
