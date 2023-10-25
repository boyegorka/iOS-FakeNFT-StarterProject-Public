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
        router?.presentPaymentTypePicker(moduleOutput: self)
    }

    func didTapSubmitRemoveNFTButton() {
        guard let shoppingOrder = stateStorage?.shoppingOrder else { return }

        let newShoppingOrder = ShoppingOrder(
            id: shoppingOrder.id,
            nfts: shoppingOrder.nfts.filter { $0 != stateStorage?.selectedRemoveNFT?.id }
        )

        view?.showProgressHUD(with: "Удаление элемента из корзины")
        interactor?.sendShoppingOrder(newShoppingOrder)
    }
}

extension ShoppingBagPresenter: ShoppingBagInteractorOutput {
    func didLoadShoppingOrder(_ shoppingOrder: ShoppingOrder?) {
        stateStorage?.shoppingOrder = shoppingOrder

        guard let nfts = shoppingOrder?.nfts else { return }

        interactor?.loadNFTs(with: nfts)
    }

    func didLoadNFTs(_ nfts: [NFT]?) {
        view?.hideProgressHUD()
        stateStorage?.nfts = nfts

        nfts?.isEmpty ?? true ? view?.showPlaceholder() : view?.hidePlaceholder()
        view?.reloadData()
        view?.setupPurchaseButton(nfts ?? [])
    }

    func didSendShoppingOrder(_ shoppingOrder: ShoppingOrder?) {
        stateStorage?.shoppingOrder = shoppingOrder

        guard let nfts = shoppingOrder?.nfts else { return }

        interactor?.loadNFTs(with: nfts)
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

                stateStorage?.selectedRemoveNFT = nft
                view?.showRemoveNFTAlert(for: cell.previewImage)
            }
        } ?? []
    }
}

extension ShoppingBagPresenter: ShoppingBagPaymentPickerModuleOutput {
    func didRecieveSuccessPaymentResults() {
        router?.hidePaymentTypePicker()
        router?.presentPaymentResults(moduleOutput: self)
    }
}

extension ShoppingBagPresenter: ShoppingBagPaymentResultsModuleOutput {
    func didTapBackButton() {
        router?.hidePaymentResults()
        view?.showProgressHUD(with: "Загрузка корзины")
        interactor?.loadShoppingOrder(with: stateStorage?.sortType ?? .name)
    }
}
