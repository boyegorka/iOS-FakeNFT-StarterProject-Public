//
//  ShoppingBagPaymentPickerRouter.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

import UIKit

protocol ShoppingBagPaymentPickerRouter {
    func presentWebView(with url: URL)
    func showPaymentErrorAlert()
}

final class ShoppingBagPaymentPickerRouterImpl {
    weak var viewController: UIViewController?
    weak var webViewController: WebViewControllerInput?
}

extension ShoppingBagPaymentPickerRouterImpl: ShoppingBagPaymentPickerRouter {
    func presentWebView(with url: URL) {
        let webViewController = WebViewController(with: url, output: self)
        self.webViewController = webViewController
        viewController?.navigationController?.pushViewController(webViewController, animated: true)
    }

    func showPaymentErrorAlert() {
        let alertController = UIAlertController(
            title: "Упс! Что-то пошло не так:(",
            message: "Попробуйте ещё раз!",
            preferredStyle: .alert
        )
        let continueAction = UIAlertAction(title: "ОК", style: .default)
        alertController.addAction(continueAction)
        viewController?.present(alertController, animated: true)
    }
}

extension ShoppingBagPaymentPickerRouterImpl: WebViewControllerOutput {
    func webViewDidLoad() {
        webViewController?.startLoading()
    }

    func didTapBackButton() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
