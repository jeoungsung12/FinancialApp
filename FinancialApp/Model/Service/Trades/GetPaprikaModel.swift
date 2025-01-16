//
//  GetPaprikaModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
struct GetPaprikaModel : Codable {
    let id : String?
    let name : String?
    let symbol : String?
    let rank : Int?
    let is_new : Bool?
    let is_active : Bool?
    let type : String?
}
struct GetImageModel : Codable {
    let id, name, symbol: String?
    let parent: Parent?
    let rank: Int?
    let isNew, isActive: Bool?
    let type: String?
    let logo: String?
    let tags: [Tag]?
    let team: [Team]?
    let description, message: String?
    let openSource, hardwareWallet: Bool?
    let started_at: String?
    let development_status, proof_type, org_structure, hash_algorithm: String?
    let contract, platform: String?
    let contracts: [Contract]?
    let links: Links?
    let links_extended: [LinksExtended]?
    let whitepaper: whitePaper?
    let first_data_at: String?
    let last_data_at: String?
}

// MARK: - Contract
struct whitePaper : Codable {
    let link : String?
    let thumbnail : String?
}
struct Contract: Codable {
    let contract, platform, type: String?
}

// MARK: - Links
struct Links: Codable {
    let explorer: [String]?
    let facebook, reddit, source_code, website: [String]?
    let youtube: [String]?
    let medium: String?
}

// MARK: - LinksExtended
struct LinksExtended: Codable {
    let url: String?
    let type: String?
    let stats: Stats?
}

// MARK: - Stats
struct Stats: Codable {
    let subscribers, contributors, stars: Int?
}

// MARK: - Parent
struct Parent: Codable {
    let id, name, symbol: String?
}

// MARK: - Tag
struct Tag: Codable {
    let id, name: String?
    let coin_counter, ico_counter: Int?
}

// MARK: - Team
struct Team: Codable {
    let id, name, position: String?
}
