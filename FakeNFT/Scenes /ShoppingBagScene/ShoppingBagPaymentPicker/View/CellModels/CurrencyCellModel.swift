//
//  CurrencyCellModel.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 16.10.2023.
//

final class CurrencyCellModel {
    let currency: Currency
    var isActive: Bool = false

    init(currency: Currency) {
        self.currency = currency
    }
}
