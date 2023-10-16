//
//  ShoppingBagPaymentPickerLoader.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 16.10.2023.
//

import Foundation

protocol ShoppingBagPaymentPickerLoader {
    func loadCurrencies(_ completion: @escaping ([Currency]?) -> Void)
    func sendPayment(currencyId: String, _ completion: @escaping (Bool) -> Void)
}

final class ShoppingBagPaymentPickerLoaderImpl {
    struct CurrenciesRequest: NetworkRequest {
        var endpoint: URL? = URL(string: "https://651ff00f906e276284c3bfac.mockapi.io/api/v1/currencies")
    }

    struct PaymentRequest: NetworkRequest {
        var endpoint: URL?

        init(currencyId: String) {
            self.endpoint = URL(string: "https://651ff00f906e276284c3bfac.mockapi.io/api/v1/orders/1/payment/\(currencyId)")
        }
    }

    private let client: NetworkClient = DefaultNetworkClient()
    private var currenciesTask: NetworkTask?
    private var paymentTask: NetworkTask?
}

extension ShoppingBagPaymentPickerLoaderImpl: ShoppingBagPaymentPickerLoader {
    func loadCurrencies(_ completion: @escaping ([Currency]?) -> Void) {
        if currenciesTask != nil {
            currenciesTask?.cancel()
            currenciesTask = nil
        }

        currenciesTask = client.send(request: CurrenciesRequest(), type: [Currency].self) { [weak self] result in
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
    }

    func sendPayment(currencyId: String, _ completion: @escaping (Bool) -> Void) {
        if paymentTask != nil {
            paymentTask?.cancel()
            paymentTask = nil
        }

        paymentTask = client.send(request: PaymentRequest(currencyId: currencyId), type: PaymentInfo.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let paymentInfo):
                DispatchQueue.main.async {
                    completion(paymentInfo.success)
                }
            case .failure:
                DispatchQueue.main.async {
                    completion(false)
                }
            }

            paymentTask = nil
        }
    }
}
