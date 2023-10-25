//
//  ShoppingBagPaymentResultsAssembly.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 16.10.2023.
//

import UIKit

final class ShoppingBagPaymentResultsAssembly {
    private init() {}

    static func assemble(moduleOutput: ShoppingBagPaymentResultsModuleOutput? = nil) -> UIViewController {
        let viewController = ShoppingBagPaymentResultsViewController()
        let presenter = ShoppingBagPaymentResultsPresenter()

        viewController.output = presenter
        presenter.view = viewController
        presenter.moduleOutput = moduleOutput

        return viewController
    }
}
