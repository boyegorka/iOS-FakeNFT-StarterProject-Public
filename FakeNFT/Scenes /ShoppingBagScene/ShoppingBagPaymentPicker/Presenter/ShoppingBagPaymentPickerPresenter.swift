//
//  ShoppingBagPaymentPickerPresenter.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

import Foundation

final class ShoppingBagPaymentPickerPresenter {
    weak var view: ShoppingBagPaymentPickerViewInput?
    var interactor: ShoppingBagPaymentPickerInteractor?
    var router: ShoppingBagPaymentPickerRouter?
    var dataSource: ShoppingBagPaymentPickerDataSource?
}

extension ShoppingBagPaymentPickerPresenter: ShoppingBagPaymentPickerViewOutput {
    func viewDidLoad() {
        print(#function)
    }

    func didTapRulesLink(with url: URL) {
        router?.presentWebView(with: url)
    }
}

extension ShoppingBagPaymentPickerPresenter: ShoppingBagPaymentPickerModule {
    var numberOfCurrencies: Int {
        3
    }

    var cellModels: [CurrencyCellModel] {
        [
            CurrencyCellModel(
                currency: Currency(
                    title: "Bitcoin",
                    name: "BTC",
                    image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Bitcoin_(BTC).png",
                    id: "1"
                )
            ),
            CurrencyCellModel(
                currency: Currency(
                    title: "Dogecoin",
                    name: "DOGE",
                    image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Dogecoin_(DOGE).png",
                    id: "2"
                )
            ),
            CurrencyCellModel(
                currency: Currency(
                    title: "Tether",
                    name: "USDT",
                    image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Tether_(USDT).png",
                    id: "3"
                )
            )
        ]
    }
}
