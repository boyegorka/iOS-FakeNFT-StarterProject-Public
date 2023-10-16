//
//  ShoppingBagPaymentPickerViewController.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 11.10.2023.
//

import UIKit

final class ShoppingBagPaymentPickerViewController: UIViewController {
    var output: ShoppingBagPaymentPickerViewOutput?

    private let currenciesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)

        return collectionView
    }()

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

    func setDataSource(_ dataSource: UICollectionViewDataSource) {
        currenciesCollectionView.dataSource = dataSource
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        purchaseButton.addTarget(self, action: #selector(didTapPurchaseButton), for: .touchUpInside)

        currenciesCollectionView.register(CurrencyCell.self)

        currenciesCollectionView.delegate = self
        rulesTextView.delegate = self
        tabBarController?.tabBar.isHidden = true

        view.addSubview(currenciesCollectionView)
        view.addSubview(rulesContainer)
        rulesContainer.addSubview(rulesTextView)
        rulesContainer.addSubview(purchaseButton)

        setupNavBar()
        setupConstraints()

        output?.viewDidLoad()
    }
}

extension ShoppingBagPaymentPickerViewController: ShoppingBagPaymentPickerViewInput {
    func reloadData() {
        currenciesCollectionView.reloadData()
    }

    func showProgressHUD(with message: String?) {
        UIBlockingProgressHUD.show(with: message)
    }

    func hideProgressHUD() {
        UIBlockingProgressHUD.dismiss()
    }
}

extension ShoppingBagPaymentPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CurrencyCell else {
            return
        }

        cell.setActiveState(true)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CurrencyCell else {
            return
        }

        cell.setActiveState(false)
    }
}

extension ShoppingBagPaymentPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: (collectionView.frame.width - 32 - 7) / 2,
            height: 46
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        7
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        7
    }
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
            currenciesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currenciesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currenciesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currenciesCollectionView.bottomAnchor.constraint(equalTo: rulesContainer.topAnchor),

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

    @objc func didTapPurchaseButton() {
        print(#function)
    }
}
