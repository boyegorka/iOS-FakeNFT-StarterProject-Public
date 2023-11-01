//
//  ShoppingBagPaymentPickerInteractor.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

protocol ShoppingBagPaymentPickerInteractor {
    func loadCurrencies()
    func sendPayment(with currency: Currency)
}

protocol ShoppingBagPaymentPickerInteractorOutput: AnyObject {
    func didLoadCurrencies(_ currencies: [Currency]?)
    func didSendPayment(_ success: Bool)
}

final class ShoppingBagPaymentPickerInteractorImpl {
    weak var output: ShoppingBagPaymentPickerInteractorOutput?
    var loader: ShoppingBagPaymentPickerLoader? = ShoppingBagPaymentPickerLoaderImpl()
}

extension ShoppingBagPaymentPickerInteractorImpl: ShoppingBagPaymentPickerInteractor {
    func loadCurrencies() {
        loader?.loadCurrencies { [weak self] currencies in
            guard let self else { return }

            output?.didLoadCurrencies(currencies)
        }
    }

    func sendPayment(with currency: Currency) {
        loader?.sendPayment(currencyId: currency.id) { [weak self] status in
            self?.output?.didSendPayment(status)
        }
    }
}
