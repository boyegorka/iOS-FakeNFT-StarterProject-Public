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
    var webViewController: WebViewControllerInput?
}

extension ShoppingBagPaymentPickerRouterImpl: ShoppingBagPaymentPickerRouter {
    func presentWebView(with url: URL) {
        let webViewController = WebViewController(with: url, output: self)
        self.webViewController = webViewController
        viewController?.navigationController?.pushViewController(webViewController, animated: true)
    }
}

extension ShoppingBagPaymentPickerRouterImpl: WebViewControllerOutput {
    func viewDidLoad() {
        webViewController?.startLoading()
    }

    func didTapBackButton() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
