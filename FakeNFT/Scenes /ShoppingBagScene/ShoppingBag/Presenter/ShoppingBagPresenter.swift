//
//  ShoppingBagPresenter.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import Foundation

final class ShoppingBagPresenter {
    weak var view: ShoppingBagViewInput?
    var stateStorage: ShoppingBagStateStorage?
    var interactor: ShoppingBagInteractor?
    var router: ShoppingBagRouter?
    var dataSource: ShoppingBagDataSource?
}

extension ShoppingBagPresenter: ShoppingBagViewOutput {
    func viewDidLoad() {
        view?.showProgressHUD(with: "Загрузка корзины")
        interactor?.loadShoppingOrder(with: stateStorage?.sortType ?? .name)
    }

    func didTapSortButton() {
        router?.presentSortTypePickerAlert()
    }

    func didTapPurchaseButton() {
        router?.presentPaymentTypePicker()
    }
}

extension ShoppingBagPresenter: ShoppingBagInteractorOutput {
    func didLoadShoppingOrder(_ shoppingOrder: ShoppingOrder?) {
        stateStorage?.shoppingOrder = shoppingOrder

        guard let nfts = shoppingOrder?.nfts else { return }

        interactor?.loadNFTs(with: nfts)
    }

    func didLoadOrders(_ nfts: [NFT]?) {
        view?.hideProgressHUD()
        stateStorage?.nfts = nfts

        view?.reloadData()
        view?.setupPurchaseButton(nfts ?? [])
    }
}

extension ShoppingBagPresenter: ShoppingBagRouterOutput {
    func didSelectSortType(_ sortType: ShoppingBagSortType) {
        view?.showProgressHUD(with: "Загрузка корзины")
        stateStorage?.sortType = sortType
        interactor?.loadShoppingOrder(with: stateStorage?.sortType ?? .name)
    }
}

extension ShoppingBagPresenter: ShoppingBagModule {
    var numberOfNFTs: Int { stateStorage?.nfts?.count ?? .zero }
    var nftCellModels: [OrderCellModel] {
        stateStorage?.nfts?.compactMap { nft in
            guard let imageURL = URL(string: nft.images.first ?? "") else{
                return nil
            }

            return OrderCellModel(
                title: nft.name,
                rating: nft.rating,
                price: nft.price,
                imageURL: imageURL
            ) { [weak self] cell in
                guard let self else { return }

                view?.showRemoveNFTAlert(for: cell.previewImage)
            }
        } ?? []
    }
}
