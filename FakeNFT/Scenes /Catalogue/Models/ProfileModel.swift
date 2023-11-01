//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 24.10.2023.
//

import Foundation

struct ProfileResult: Codable {
    let id: String
    let likes: [String]
}

struct ProfileModel {
    let id: String
    let likes: [String]
    
    init(profileResult: ProfileResult) {
        self.id = profileResult.id
        self.likes = profileResult.likes
    }
}
