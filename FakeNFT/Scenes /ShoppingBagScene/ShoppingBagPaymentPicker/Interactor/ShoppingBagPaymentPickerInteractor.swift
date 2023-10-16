//
//  ShoppingBagPaymentPickerInteractor.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

protocol ShoppingBagPaymentPickerInteractor {
    func loadCurrencies()
}

protocol ShoppingBagPaymentPickerInteractorOutput: AnyObject {
    func didLoadCurrencies(_ currencies: [Currency]?)
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
}
