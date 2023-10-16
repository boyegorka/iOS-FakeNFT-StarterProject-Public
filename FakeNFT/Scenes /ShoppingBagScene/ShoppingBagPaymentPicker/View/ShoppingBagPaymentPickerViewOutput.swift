//
//  ShoppingBagPaymentPickerViewOutput.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

import Foundation

protocol ShoppingBagPaymentPickerViewOutput {
    func viewDidLoad()

    func didSelectCurrency(at indexPath: IndexPath)
    func didTapRulesLink(with url: URL)
    func didTapPurchaseButton()
}
