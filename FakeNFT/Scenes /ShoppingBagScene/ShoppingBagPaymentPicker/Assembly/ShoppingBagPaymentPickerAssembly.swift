//
//  ShoppingBagPaymentPickerAssembly.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

import UIKit

final class ShoppingBagPaymentPickerAssembly {
    private init() {}

    static func assemble() -> UIViewController {
        let interactor = ShoppingBagPaymentPickerInteractorImpl()
        let router = ShoppingBagPaymentPickerRouterImpl()
        let dataSource = ShoppingBagPaymentPickerDataSource()
        let presenter = ShoppingBagPaymentPickerPresenter()

        let viewController = ShoppingBagPaymentPickerViewController()
        viewController.output = presenter
        viewController.setDataSource(dataSource)

        dataSource.module = presenter
        router.viewController = viewController
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        presenter.dataSource = dataSource

        return viewController
    }
}
