//
//  ShoppingBagInteractor.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import Foundation

protocol ShoppingBagInteractor {
    func loadShoppingOrder()
}

protocol ShoppingBagInteractorOutput: AnyObject {
    func didLoadShoppingOrder(_ shoppingOrder: ShoppingOrder?)
}

final class ShoppngBagInteractorImpl {
    weak var output: ShoppingBagInteractorOutput?
    var loader: ShoppingBagLoader? = ShoppingBagLoaderImpl()
}

extension ShoppngBagInteractorImpl: ShoppingBagInteractor {
    func loadShoppingOrder() {
        loader?.loadShoppingOrder { [weak self] shoppingOrder in
            self?.output?.didLoadShoppingOrder(shoppingOrder)
        }
    }
}
