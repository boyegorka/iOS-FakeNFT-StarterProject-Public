//
//  ShoppingBagViewInput.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import UIKit

protocol ShoppingBagViewInput: AnyObject {
    func reloadData()

    func showProgressHUD(with message: String?)
    func hideProgressHUD()

    func setupPurchaseButton(_ nfts: [NFT])
    func showRemoveNFTAlert(for preview: UIImage)
}
