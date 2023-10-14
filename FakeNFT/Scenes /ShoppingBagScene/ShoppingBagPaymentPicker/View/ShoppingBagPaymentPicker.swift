//
//  ShoppingBagPaymentPicker.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 11.10.2023.
//

import UIKit

final class ShoppingBagPaymentPicker: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationItem.title = "Выберите способ оплаты"
        navigationItem.hidesBackButton = true

        let leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "backButton"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )

        leftBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}

private extension ShoppingBagPaymentPicker {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
