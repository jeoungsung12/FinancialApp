//
//  GetPaprikaModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
struct GetPaprikaModel : Decodable {
    let id : String
    let name : String
}
struct GetImageModel : Decodable {
    let logo: String?
    let whitepaper: whitePaper?
}

// MARK: - Contract
struct whitePaper : Codable {
    let link : String?
    let thumbnail : String?
}
