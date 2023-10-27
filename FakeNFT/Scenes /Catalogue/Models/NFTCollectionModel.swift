//
//  CatalogueCellModel.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 11.10.2023.
//

import Foundation

struct NFTCollectionResult: Codable {
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

struct NFTCollectionModel {
    let name: String
    let cover: URL?
    let nfts: [String]
    let description: String
    let author: String
    let id: String
    
    init(collectionResult: NFTCollectionResult) {
        self.name = collectionResult.name
        self.cover = collectionResult.cover.getUrl()
        self.nfts = collectionResult.nfts
        self.description = collectionResult.description
        self.author = collectionResult.author
        self.id = collectionResult.id
    }
}
