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
        view?.showProgressHUD()
        interactor?.loadShoppingOrder()
    }
}

extension ShoppingBagPresenter: ShoppingBagInteractorOutput {
    func didLoadShoppingOrder(_ shoppingOrder: ShoppingOrder?) {
        view?.hideProgressHUD()
        print(shoppingOrder)
    }
}
