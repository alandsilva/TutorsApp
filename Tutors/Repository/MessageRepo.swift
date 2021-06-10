//
//  MessageRepo.swift
//  Tutors
//
//  Created by Alan on 4.6.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

import Combine
import Resolver

class BaseMessageRepo {
    @Published var messages = [Message]()
}

protocol MessageRepo: BaseMessageRepo {
    func addMessage(_ message: Message)
}

class FirestoreMessageRepo: BaseMessageRepo, MessageRepo, ObservableObject {
    @Injected var authenticationService: AuthenticationService
    let db = Firestore.firestore()
    
    var chatId: String = "unknow"
    var chatsPath: String = "chats"
    var messagesPath: String = "messages"
    var userId: String = "unknown"
    
    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    init(_ id: String) {
        super.init()
        
        chatId = id
        
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
        // (re)load data if user changes
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.loadData()
            }
            .store(in: &cancellables)
    }
    
    func loadData() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        listenerRegistration = db.collection(chatsPath).document(chatId).collection(messagesPath)
            .addSnapshotListener { querySnapshot, error in
                if let qSnapshot = querySnapshot {
                    self.messages = qSnapshot.documents.compactMap{ document in
                        try? document.data(as: Message.self)
                    }
                }
            }
    }
    
    func addMessage(_ message: Message) {
        do {
            var newMessage = message
            newMessage.userId = userId
            let _ = try db.collection(chatsPath).document(chatId).collection(messagesPath).addDocument(from: newMessage)
            print("Message sent: \(newMessage)")
        }
        catch {
            fatalError("Unable to encode chat: \(error.localizedDescription).")
        }
    }
    
}


