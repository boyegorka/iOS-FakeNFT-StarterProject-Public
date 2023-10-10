//
//  ShoppingBagInteractor.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import Foundation

protocol ShoppingBagInteractor {
    func loadShoppingOrder()
    func loadNFTs(with ids: [String])
}

protocol ShoppingBagInteractorOutput: AnyObject {
    func didLoadShoppingOrder(_ shoppingOrder: ShoppingOrder?)
    func didLoadOrders(_ nfts: [NFT]?)
}

final class ShoppngBagInteractorImpl {
    weak var output: ShoppingBagInteractorOutput?
    var loader: ShoppingBagLoader? = ShoppingBagLoaderImpl()
    var nfts: ReferenceWrapper<[NFT]> = ReferenceWrapper(wrappedValue: [])
}

extension ShoppngBagInteractorImpl: ShoppingBagInteractor {
    func loadShoppingOrder() {
        loader?.loadShoppingOrder { [weak self] shoppingOrder in
            self?.output?.didLoadShoppingOrder(shoppingOrder)
        }
    }

    func loadNFTs(with ids: [String]) {
        let dispatchGroup = DispatchGroup()

        for id in ids {
            dispatchGroup.enter()
            loader?.loadNFT(with: id) { [weak self] nft in
                guard let self, let nft else { return }

                dispatchGroup.leave()
                nfts.wrappedValue.append(nft)
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }

            output?.didLoadOrders(nfts.wrappedValue.isEmpty ? nil : nfts.wrappedValue)
        }
    }
}
