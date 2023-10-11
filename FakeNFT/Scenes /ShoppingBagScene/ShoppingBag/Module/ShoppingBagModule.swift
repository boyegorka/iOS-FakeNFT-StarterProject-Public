//
//  ShoppingBagModule.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

protocol ShoppingBagModule: AnyObject {
    var numberOfNFTs: Int { get }
    var nftCellModels: [OrderCellModel] { get }
}
