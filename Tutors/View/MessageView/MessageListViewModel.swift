//
//  MessageListViewModel.swift
//  Tutors
//
//  Created by Alan on 9.6.2021.
//

import Foundation
import Combine

class MessageListViewModel: ObservableObject {
    @Published var messageRepo: FirestoreMessageRepo
    @Published var messageCellVMs = [MessageCellViewModel]()
    var userID: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ uId: String) {
        messageRepo = FirestoreMessageRepo(uId)
        messageRepo.$messages
            .map { messages in
                messages.map { message in
                    MessageCellViewModel(message: message)
                }
            }
            .assign(to: \.messageCellVMs, on: self)
            .store(in: &cancellables)
    }
    
    func sendMessage(_ message: String){
        print("Call send message inside ViewModel")
        messageRepo.addMessage(Message(message: message, userId: ""))
    }
    
    func sendEvent(_ eventID: String) {
        print("Call send event inside ViewModel")
        messageRepo.addMessage(Message(message: "EVENT REQUEST", eventId: eventID))
    }
}
