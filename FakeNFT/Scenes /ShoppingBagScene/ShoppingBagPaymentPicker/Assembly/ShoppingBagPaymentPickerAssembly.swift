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
        let presenter = ShoppingBagPaymentPickerPresenter()

        let viewController = ShoppingBagPaymentPickerViewController()
        viewController.output = presenter

        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router

        return viewController
    }
}
