//
//  ShoppingBagPaymentPickerModule.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 16.10.2023.
//

protocol ShoppingBagPaymentPickerModule: AnyObject {
    var numberOfCurrencies: Int { get }
    var cellModels: [CurrencyCellModel] { get }
}
