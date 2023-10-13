//
//  ShoppingBagPaymentPickerViewController.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 11.10.2023.
//

import UIKit

final class ShoppingBagPaymentPickerViewController: UIViewController {
    var output: ShoppingBagPaymentPickerViewOutput?

    override func viewDidLoad() {
        view.backgroundColor = .white

        setupNavBar()
        setupConstraints()

        output?.viewDidLoad()
    }
}

extension ShoppingBagPaymentPickerViewController: ShoppingBagPaymentPickerViewInput {
}

private extension ShoppingBagPaymentPickerViewController {
    func setupNavBar() {
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

    func setupConstraints() {
    }

    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
