//
//  ChatServiceModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/08.
//

import Foundation

struct ChatServiceModel : Codable {
    let choices : [Choice]
}
struct Choice : Codable {
    let message: Message
}
struct Message: Codable {
    let content: String
}
