//
//  CatalogueCellModel.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 11.10.2023.
//

import Foundation

struct CollectionResult: Codable {
    let name: String
    let cover: String
    let nfts: [String]
    let id: String
}

struct CollectionModel {
    let name: String
    let cover: URL?
    let nfts: [String]
    let id: String
    
    init(collectionResult: CollectionResult) {
        self.name = collectionResult.name
        self.cover = URL(string: collectionResult.cover)
        self.nfts = collectionResult.nfts
        self.id = collectionResult.id
    }
}
