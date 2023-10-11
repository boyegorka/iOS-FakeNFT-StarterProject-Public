//
//  ShoppingBagViewInput.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

protocol ShoppingBagViewInput: AnyObject {
    func reloadData()

    func showProgressHUD(with message: String?)
    func hideProgressHUD()

    func setupPurchaseButton(_ nfts: [NFT])
}
