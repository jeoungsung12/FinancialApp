//
//  ChatServiceModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/08.
//

import Foundation

struct ChatServiceModel: Decodable {
    let choices: [ChatChoice]
}
struct ChatChoice: Decodable {
    let message: ChatMessage
}
struct ChatMessage: Decodable {
    let content: String
}
