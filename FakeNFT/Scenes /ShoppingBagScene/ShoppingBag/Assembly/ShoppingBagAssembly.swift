//
//  ShoppingBagAssembly.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import UIKit

final class ShoppingBagAssembly {
    private init() {}

    // FIXME: на самом деле все мы понимаем что собираться модуль должен снаружи, однако посколкьу экраны собираются в начале в сториборде
    // FIXME: то приходится костыльно модулю просить самому себя собрать ассемблер:( не делайте так в продакшене!
    static func assemble(viewController: ShoppingBagViewController & ShoppingBagViewInput) {
        let interactor = ShoppngBagInteractorImpl()
        let presenter = ShoppingBagPresenter()

        viewController.output = presenter

        presenter.view = viewController
        presenter.interactor = interactor

        interactor.output = presenter
    }
}
