//
//  ShoppingBagPaymentResultsPresenter.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 16.10.2023.
//

protocol ShoppingBagPaymentResultsModuleOutput: AnyObject {
    func didTapBackButton()
}

final class ShoppingBagPaymentResultsPresenter {
    weak var view: ShoppingBagPaymentResultsViewInput?
    weak var moduleOutput: ShoppingBagPaymentResultsModuleOutput?
}

extension ShoppingBagPaymentResultsPresenter: ShoppingBagPaymentResultsViewOutput {
    func didTapBackButton() {
        moduleOutput?.didTapBackButton()
    }
}
