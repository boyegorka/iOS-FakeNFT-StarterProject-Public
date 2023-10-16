//
//  ShoppingBagPaymentPickerViewInput.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

protocol ShoppingBagPaymentPickerViewInput: AnyObject {
    func reloadData()

    func showProgressHUD(with message: String?)
    func hideProgressHUD()
}
