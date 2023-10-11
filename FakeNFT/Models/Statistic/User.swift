//
//  User.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 11.10.2023.
//

import Foundation

struct User: Codable {
    var name: String
    var avatarUrl: String
    var description: String
    var website: String
    var nfts: [String]
    var rating: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, website, rating, nfts
        case avatarUrl = "avatar"
    }
}
