//
//  ShoppingBagPaymentPickerRouter.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

import UIKit

protocol ShoppingBagPaymentPickerRouter {
    func presentWebView(with url: URL)
}

final class ShoppingBagPaymentPickerRouterImpl {
    var viewController: UIViewController?
}

extension ShoppingBagPaymentPickerRouterImpl: ShoppingBagPaymentPickerRouter {
    func presentWebView(with url: URL) {
        // TODO: сделать открытие webViewController-а
    }
}
