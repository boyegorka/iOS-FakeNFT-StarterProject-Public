//
//  ShoppingBagLoader.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import Foundation

protocol ShoppingBagLoader {
    func loadShoppingOrder(_ completion: @escaping (ShoppingOrder?) -> Void)
    func loadNFT(with nftId: String, completion: @escaping (NFT?) -> Void)
}

final class ShoppingBagLoaderImpl {
    struct ShoppingBagRequest: NetworkRequest {
        let endpoint: URL? = URL(string: "https://651ff00f906e276284c3bfac.mockapi.io/api/v1/orders/1")
    }

    struct NFTRequest: NetworkRequest {
        var endpoint: URL? = nil

        init(with nftId: String) {
            endpoint = URL(string: "https://651ff00f906e276284c3bfac.mockapi.io/api/v1/nft/\(nftId)")
        }
    }

    struct NFTTask {
        let nftId: String
        var task: NetworkTask?
    }

    private let client: NetworkClient = DefaultNetworkClient()
    private var shoppingOrderTask: NetworkTask?
    private var nftTasks: [NFTTask]?
}

extension ShoppingBagLoaderImpl: ShoppingBagLoader {
    func loadShoppingOrder(_ completion: @escaping (ShoppingOrder?) -> Void) {
        if shoppingOrderTask != nil {
            shoppingOrderTask?.cancel()
            shoppingOrderTask = nil
        }

        shoppingOrderTask = client.send(
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

            shoppingOrderTask = nil
        }
    }

    func loadNFT(with nftId: String, completion: @escaping (NFT?) -> Void) {
        removeNFTTask(with: nftId)

        let task = client.send(
            request: NFTRequest(with: nftId),
            type: NFT.self
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let nft):
                DispatchQueue.main.async {
                    completion(nft)
                }
            case .failure:
                DispatchQueue.main.async {
                    completion(nil)
                }
            }

            removeNFTTask(with: nftId)
        }
        let nftTask = NFTTask(nftId: nftId, task: task)
        nftTasks?.append(nftTask)
    }
}

private extension ShoppingBagLoaderImpl {
    func removeNFTTask(with nftId: String) {
        if let nftTaskIndex = nftTasks?.firstIndex(where: { $0.nftId == nftId }) {
            let nftTask = nftTasks?[nftTaskIndex]
            nftTask?.task?.cancel()

            nftTasks?.remove(at: nftTaskIndex)
        }
    }
}
