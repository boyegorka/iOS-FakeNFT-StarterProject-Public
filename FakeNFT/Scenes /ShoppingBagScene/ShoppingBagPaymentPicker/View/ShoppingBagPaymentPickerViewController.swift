//
//  ShoppingBagPaymentPickerViewController.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 11.10.2023.
//

import UIKit

final class ShoppingBagPaymentPickerViewController: UIViewController {
    var output: ShoppingBagPaymentPickerViewOutput?

    private let rulesContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypLightGray
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true

        return view
    }()

    private let rulesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.backgroundColor = .ypLightGray

        let rulesText = NSMutableAttributedString(string: "Совершая покупку, вы соглашаетесь с условиями ")
        let linkText = NSAttributedString(
            string: "Пользовательского соглашения",
            attributes: [
                .link: "https://yandex.ru/legal/practicum_termsofuse/",
                .font: UIFont.caption2,
            ]
        )
        rulesText.append(linkText)

        textView.attributedText = rulesText

        return textView
    }()

    private let purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.backgroundColor = .ypBlack
        button.tintColor = .white

        let title = NSAttributedString(
            string: "Оплатить",
            attributes: [
                .font: UIFont.bodyBold
            ]
        )

        button.setAttributedTitle(title, for: .normal)

        return button
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white

        rulesTextView.delegate = self

        tabBarController?.tabBar.isHidden = true

        view.addSubview(rulesContainer)
        rulesContainer.addSubview(rulesTextView)
        rulesContainer.addSubview(purchaseButton)

        setupNavBar()
        setupConstraints()

        output?.viewDidLoad()
    }
}

extension ShoppingBagPaymentPickerViewController: ShoppingBagPaymentPickerViewInput {
}

extension ShoppingBagPaymentPickerViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        output?.didTapRulesLink(with: URL)

        return false
    }
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
        NSLayoutConstraint.activate([
            rulesContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rulesContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rulesContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            rulesContainer.heightAnchor.constraint(equalToConstant: 152),

            rulesTextView.leadingAnchor.constraint(equalTo: rulesContainer.leadingAnchor, constant: 16),
            rulesTextView.trailingAnchor.constraint(equalTo: rulesContainer.trailingAnchor, constant: -16),
            rulesTextView.topAnchor.constraint(equalTo: rulesContainer.topAnchor, constant: 16),
            rulesTextView.heightAnchor.constraint(equalToConstant: 44),

            purchaseButton.leadingAnchor.constraint(equalTo: rulesContainer.leadingAnchor, constant: 16),
            purchaseButton.trailingAnchor.constraint(equalTo: rulesContainer.trailingAnchor, constant: -16),
            purchaseButton.topAnchor.constraint(equalTo: rulesTextView.bottomAnchor, constant: 16),
            purchaseButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
