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
        let stateStorage = ShoppingBagStateStorage()
        let interactor = ShoppngBagInteractorImpl()
        let dataSource = ShoppingBagDataSource()
        let presenter = ShoppingBagPresenter()

        viewController.output = presenter
        viewController.setDataSource(dataSource)

        presenter.view = viewController
        presenter.stateStorage = stateStorage
        presenter.interactor = interactor
        presenter.dataSource = dataSource

        interactor.output = presenter
        dataSource.module = presenter
    }
}
