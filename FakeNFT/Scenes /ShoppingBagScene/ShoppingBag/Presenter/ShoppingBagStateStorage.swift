//
//  ShoppingBagStateStorage.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 11.10.2023.
//

enum ShoppingBagSortType: String {
    case price
    case rating
    case name
}

final class ShoppingBagStateStorage {
    var shoppingOrder: ShoppingOrder?
    var nfts: [NFT]?
    var selectedRemoveNFT: NFT?
    var sortType: ShoppingBagSortType = .name
}
