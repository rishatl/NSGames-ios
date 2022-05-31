//
//  FirebaseService.swift
//  NSGames
//
//  Created by Rishat Latypov on 26.03.2022
//

import Foundation
import Firebase

class ConversationFirebaseService: ConversationsFirebaseServiceProtocol {
    public static let shared = ConversationFirebaseService()
    var conversations: CollectionReference?

    private lazy var users = Firestore.firestore().collection(FirebaseNames.usersCollection)

    private init() { }

    func setListeners(to myId: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        conversations = users.document(myId).collection(FirebaseNames.conversationsCollection)
        conversations?.addSnapshotListener({ result, error in
            if let error = error {
                completion(.failure(error))
            }

            if let docs = result?.documents {
                var conversations = [Conversation]()
                for doc in docs {
                    let data = doc.data()
                    let id = doc.documentID
                    if let usernname = data[FirebaseNames.conversationUsername] as? String,
                       let lastMessage = data[FirebaseNames.conversationLastMessage] as? String?,
                       let lastActivity = data[FirebaseNames.conversationLastActivity] as? Timestamp? {
                        conversations.append(Conversation(id: id, username: usernname, lastActivity: lastActivity?.dateValue(), lastMessageText: lastMessage))
                    }
                }
                conversations.sort { first, second -> Bool in
                    if let firstDate = first.lastActivity {
                        if let secondDate = second.lastActivity {
                            return firstDate.compare(secondDate) == .orderedDescending
                        }
                        return false
                    }
                    return true
                }
                completion(.success(conversations))
            }
        })
    }
}
