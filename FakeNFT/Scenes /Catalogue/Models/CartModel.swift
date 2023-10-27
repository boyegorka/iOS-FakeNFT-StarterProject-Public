//
//  CartModel.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 24.10.2023.
//

import Foundation

struct CartResult: Codable {
    let id: String
    let nfts: [String]
}

struct CartModel {
    let id: String
    let nfts: [String]
    
    init(cartResult: CartResult) {
        self.id = cartResult.id
        self.nfts = cartResult.nfts
    }
}
