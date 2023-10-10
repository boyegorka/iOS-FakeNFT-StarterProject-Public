//
//  ShoppingBagLoader.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import Foundation

protocol ShoppingBagLoader {
    func loadShoppingOrder(_ completion: @escaping (ShoppingOrder?) -> Void)
}

final class ShoppingBagLoaderImpl {
    private let client: NetworkClient = DefaultNetworkClient()
    private var task: NetworkTask?

    struct ShoppingBagRequest: NetworkRequest {
        var endpoint: URL? = URL(string: "https://651ff00f906e276284c3bfac.mockapi.io/api/v1/orders/1")
    }
}

extension ShoppingBagLoaderImpl: ShoppingBagLoader {
    func loadShoppingOrder(_ completion: @escaping (ShoppingOrder?) -> Void) {
        guard task == nil else { return }

        task = client.send(
            request: ShoppingBagRequest(),
            type: ShoppingOrder.self
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let shoppingOrder):
                DispatchQueue.main.async {
                    completion(shoppingOrder)
                }
            case .failure:
                DispatchQueue.main.async {
                    completion(nil)
                }
            }

            task = nil
        }
    }
}
