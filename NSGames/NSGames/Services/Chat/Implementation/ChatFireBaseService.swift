//
//  ChatFireBaseService.swift
//  NSGames
//
//  Created by Rishat Latypov on 26.03.2022
//

import Foundation
import Firebase

class ChatFireBaseService: ChatFireBaseServiceProtocol {
    public static let shared = ChatFireBaseService()
    var otherUserName: String = ""

    private init() { }

    private lazy var users = Firestore.firestore().collection(FirebaseNames.usersCollection)

    func sendMessage(myId: String, to otherUserId: String, message: Message, completion: @escaping (Bool) -> Void) {
        let otherUserConversation = users.document(otherUserId).collection(FirebaseNames.conversationsCollection).document(myId)
        let myConversation = users.document(myId).collection(FirebaseNames.conversationsCollection).document(otherUserId)
        let otherUserMessages = users.document(otherUserId).collection(FirebaseNames.conversationsCollection).document(myId).collection(FirebaseNames.messagesCollection)
        let myMessages = users.document(myId).collection(FirebaseNames.conversationsCollection).document(otherUserId).collection(FirebaseNames.messagesCollection)
        let messageData: [String: Any] = ["content": message.content,
                                          "created": message.created,
                                          "senderId": myId]
        let otherLastMessageData: [String: Any] = ["lastMessageText": message.content,
                                                   "lastActivity": Timestamp(date: message.created),
                                                   "username": UserDefaults.standard.string(forKey: FirebaseNames.username) ?? "NoName"]
        let lastMessageData: [String: Any] = ["lastMessageText": message.content,
                                              "lastActivity": Timestamp(date: message.created),
                                              "username": otherUserName]
        otherUserConversation.setData(otherLastMessageData, merge: true)
        otherUserMessages.addDocument(data: messageData)
        myMessages.addDocument(data: messageData)
        myConversation.setData(lastMessageData, merge: true)
        return completion(true)
    }

    func setListeners(myId: String, to chatId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        let messages = users.document(myId).collection(FirebaseNames.conversationsCollection).document(chatId).collection(FirebaseNames.messagesCollection)
        messages.addSnapshotListener({ result, error in
            if let error = error {
                completion(.failure(error))
            }

            if let docs = result?.documents {
                var messagess = [Message]()
                for doc in docs {
                    let data = doc.data()
                    if let content = data[FirebaseNames.messageContent] as? String,
                       let senderId = data[FirebaseNames.messageSender] as? String,
                       let date = data[FirebaseNames.messageDate] as? Timestamp {
                        messagess.append(Message(content: content, created: date.dateValue(), senderId: senderId))
                    }
                }
                messagess.sort { $0.created.compare($1.created) == .orderedDescending }
                completion(.success(messagess))
            }
        })
    }
}
