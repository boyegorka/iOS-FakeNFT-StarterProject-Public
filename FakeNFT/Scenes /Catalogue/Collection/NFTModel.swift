//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 23.10.2023.
//

import Foundation

struct NFTModel {
    let id: String
    let name: String
    let image: URL?
    let rating: Int
    let price: Double
    let isLiked: Bool
    
    init(nft: NFT) {
        self.id = nft.id
        self.name = nft.name
        self.image = nft.images.first?.getUrl()
        self.rating = nft.rating
        self.price = nft.price
        self.isLiked = true
    }
}
