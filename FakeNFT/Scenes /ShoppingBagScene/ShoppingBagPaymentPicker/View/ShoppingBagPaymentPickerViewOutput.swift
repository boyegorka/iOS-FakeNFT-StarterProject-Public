//
//  ShoppingBagPaymentPickerViewOutput.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

import Foundation

protocol ShoppingBagPaymentPickerViewOutput {
    func viewDidLoad()

    func didTapRulesLink(with url: URL)
}
