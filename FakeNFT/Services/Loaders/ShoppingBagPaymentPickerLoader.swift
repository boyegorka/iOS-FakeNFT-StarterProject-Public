//
//  ShoppingBagPaymentPickerLoader.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 16.10.2023.
//

import Foundation

protocol ShoppingBagPaymentPickerLoader {
    func loadCurrencies(_ completion: @escaping ([Currency]?) -> Void)
}

final class ShoppingBagPaymentPickerLoaderImpl {
    struct CurrenciesRequest: NetworkRequest {
        var endpoint: URL? = URL(string: "https://651ff00f906e276284c3bfac.mockapi.io/api/v1/currencies")
    }

    private let client: NetworkClient = DefaultNetworkClient()
    private var currenciesTask: NetworkTask?
}

extension ShoppingBagPaymentPickerLoaderImpl: ShoppingBagPaymentPickerLoader {
    func loadCurrencies(_ completion: @escaping ([Currency]?) -> Void) {
        if currenciesTask != nil {
            currenciesTask?.cancel()
            currenciesTask = nil
        }

        let task = client.send(request: CurrenciesRequest(), type: [Currency].self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let currencies):
                DispatchQueue.main.async {
                    completion(currencies)
                }
            case .failure:
                DispatchQueue.main.async {
                    completion(nil)
                }
            }

            currenciesTask = nil
        }
        currenciesTask = task
    }
}
