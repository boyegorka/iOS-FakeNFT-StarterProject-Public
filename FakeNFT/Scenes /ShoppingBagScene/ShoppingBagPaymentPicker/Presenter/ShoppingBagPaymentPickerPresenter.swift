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
}

extension ShoppingBagPaymentPickerPresenter: ShoppingBagPaymentPickerViewOutput {
    func viewDidLoad() {
        print(#function)
    }

    func didTapRulesLink(with url: URL) {
        router?.presentWebView(with: url)
    }
}
