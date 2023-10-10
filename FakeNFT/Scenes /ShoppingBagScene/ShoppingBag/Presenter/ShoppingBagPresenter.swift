//
//  ShoppingBagPresenter.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import Foundation

final class ShoppingBagPresenter {
    weak var view: ShoppingBagViewInput?
    var interactor: ShoppingBagInteractor?
}

extension ShoppingBagPresenter: ShoppingBagViewOutput {
    func viewDidLoad() {
        view?.showProgressHUD(with: "Загрузка корзины")
        interactor?.loadShoppingOrder()
    }
}

extension ShoppingBagPresenter: ShoppingBagInteractorOutput {
    func didLoadShoppingOrder(_ shoppingOrder: ShoppingOrder?) {
        print(shoppingOrder)

        guard let nfts = shoppingOrder?.nfts else { return }

        interactor?.loadNFTs(with: nfts)
    }

    func didLoadOrders(_ nfts: [NFT]?) {
        view?.hideProgressHUD()
        print(nfts)
    }
}
