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
    var stateStorage: ShoppingBagPaymentPickerStateStorage?
}

extension ShoppingBagPaymentPickerPresenter: ShoppingBagPaymentPickerViewOutput {
    func viewDidLoad() {
        view?.showProgressHUD(with: "Загрузка списка валют")
        interactor?.loadCurrencies()
    }

    func didTapRulesLink(with url: URL) {
        router?.presentWebView(with: url)
    }
}

extension ShoppingBagPaymentPickerPresenter: ShoppingBagPaymentPickerInteractorOutput {
    func didLoadCurrencies(_ currencies: [Currency]?) {
        view?.hideProgressHUD()

        guard let currencies else { return }

        stateStorage?.currencies = currencies
        view?.reloadData()
    }
}

extension ShoppingBagPaymentPickerPresenter: ShoppingBagPaymentPickerModule {
    var numberOfCurrencies: Int {
        stateStorage?.currencies?.count ?? .zero
    }

    var cellModels: [CurrencyCellModel] {
        stateStorage?.currencies?.map { currency in
            CurrencyCellModel(currency: currency)
        } ?? []
    }
}
