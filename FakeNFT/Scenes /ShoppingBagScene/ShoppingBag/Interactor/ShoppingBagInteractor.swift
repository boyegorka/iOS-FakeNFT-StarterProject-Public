//
//  ShoppingBagInteractor.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import Foundation

protocol ShoppingBagInteractor {
    func loadShoppingOrder(with sortType: ShoppingBagSortType)
    func loadNFTs(with ids: [String], sortType: ShoppingBagSortType?)

    func sendShoppingOrder(_ shoppingOrder: ShoppingOrder)
}

protocol ShoppingBagInteractorOutput: AnyObject {
    func didLoadShoppingOrder(_ shoppingOrder: ShoppingOrder?)
    func didLoadNFTs(_ nfts: [NFT]?)
    func didSendShoppingOrder(_ shoppingOrder: ShoppingOrder?)
}

final class ShoppngBagInteractorImpl {
    weak var output: ShoppingBagInteractorOutput?
    var loader: ShoppingBagLoader? = ShoppingBagLoaderImpl()
    var nfts: ReferenceWrapper<[NFT]> = ReferenceWrapper(wrappedValue: [])
}

extension ShoppngBagInteractorImpl: ShoppingBagInteractor {
    func loadShoppingOrder(with sortType: ShoppingBagSortType) {
        loader?.loadShoppingOrder(with: sortType) { [weak self] shoppingOrder in
            self?.output?.didLoadShoppingOrder(shoppingOrder)
        }
    }

    func loadNFTs(with ids: [String], sortType: ShoppingBagSortType?) {
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

            let sortedNFTs = nfts.wrappedValue.sorted { lhsNFT, rhsNFT in
                let sortType = sortType ?? .name

                switch sortType {
                case .price:
                    return lhsNFT.price < rhsNFT.price
                case .rating:
                    return lhsNFT.rating < rhsNFT.rating
                case .name:
                    return lhsNFT.name < rhsNFT.name
                }
            }

            output?.didLoadNFTs(nfts.wrappedValue.isEmpty ? nil : sortedNFTs)
            nfts.wrappedValue.removeAll()
        }
    }

    func sendShoppingOrder(_ shoppingOrder: ShoppingOrder) {
        loader?.sendShoppingOrder(shoppingOrder) { [weak self] shoppingOrder in
            self?.output?.didSendShoppingOrder(shoppingOrder)
        }
    }
}
