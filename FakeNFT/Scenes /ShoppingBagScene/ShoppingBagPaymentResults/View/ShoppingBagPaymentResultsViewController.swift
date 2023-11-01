//
//  ShoppingBagPaymentResultsViewController.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 16.10.2023.
//

import UIKit

protocol ShoppingBagPaymentResultsViewInput: AnyObject {
}

protocol ShoppingBagPaymentResultsViewOutput {
    func didTapBackButton()
}

final class ShoppingBagPaymentResultsViewController: UIViewController {
    var output: ShoppingBagPaymentResultsViewOutput?

    private lazy var digitalArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "digitalArt")

        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline3
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        label.numberOfLines = 2
        label.textAlignment = .center

        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.backgroundColor = .textPrimary
        button.tintColor = .white

        let title = NSAttributedString(
            string: "Вернуться в каталог",
            attributes: [
                .font: UIFont.bodyBold
            ]
        )

        button.setAttributedTitle(title, for: .normal)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        navigationItem.hidesBackButton = true
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .ypWhite

        view.addSubview(digitalArtImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(backButton)

        setupContraints()
    }
}

extension ShoppingBagPaymentResultsViewController: ShoppingBagPaymentResultsViewInput {
}

private extension ShoppingBagPaymentResultsViewController {
    func setupContraints() {
        NSLayoutConstraint.activate([
            digitalArtImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitalArtImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            digitalArtImageView.heightAnchor.constraint(equalToConstant: 278),
            digitalArtImageView.widthAnchor.constraint(equalToConstant: 278),

            descriptionLabel.topAnchor.constraint(equalTo: digitalArtImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36),

            backButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            backButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func didTapBackButton() {
        output?.didTapBackButton()
    }
}
