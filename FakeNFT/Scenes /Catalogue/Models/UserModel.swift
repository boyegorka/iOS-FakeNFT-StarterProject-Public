//
//  UserModel.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 24.10.2023.
//

import Foundation

struct UserResult: Codable {
    let id: String
    let name: String
    let website: String
}

struct UserModel {
    let id: String
    let name: String
    let website: URL?
    
    init(userResult: UserResult) {
        self.id = userResult.id
        self.name = userResult.name
        self.website = URL(string: userResult.website)
    }
}
