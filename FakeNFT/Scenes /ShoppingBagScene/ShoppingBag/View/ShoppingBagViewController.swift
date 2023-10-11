//
//  ShoppingTabViewController.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 08.10.2023.
//

import UIKit

final class ShoppingBagViewController: UIViewController {

    var output: ShoppingBagViewOutput?

    private let nftsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

        return tableView
    }()

    private let purchaseContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundLightGray
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true

        return view
    }()

    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("К оплате", for: .normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.backgroundColor = .textPrimary
        button.tintColor = .white

        return button
    }()

    private var purchaseButtonContainerHeight: NSLayoutConstraint?

    private let nftRemoveView: NFTRemoveView = {
        let removeView = NFTRemoveView()
        removeView.translatesAutoresizingMaskIntoConstraints = false
        removeView.alpha = 0

        return removeView
    }()

    func setDataSource(_ dataSource: UITableViewDataSource) {
        nftsTableView.dataSource = dataSource
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingBagAssembly.assemble(viewController: self)

        nftsTableView.register(OrderCell.self)

        purchaseButton.addTarget(self, action: #selector(didTapPurchaseButton), for: .touchUpInside)

        view.backgroundColor = .background

        view.addSubview(nftsTableView)
        view.addSubview(purchaseContainer)
        purchaseContainer.addSubview(nftCountLabel)
        purchaseContainer.addSubview(totalPriceLabel)
        purchaseContainer.addSubview(purchaseButton)

        setupNavBar()
        setupConstraints()
        setupNFTRemoveView()

        output?.viewDidLoad()
    }

}

extension ShoppingBagViewController: ShoppingBagViewInput {
    func reloadData() {
        nftsTableView.reloadData()
    }

    func showProgressHUD(with message: String? = nil) {
        UIBlockingProgressHUD.show(with: message)
    }

    func hideProgressHUD() {
        UIBlockingProgressHUD.dismiss()
    }

    func setupPurchaseButton(_ nfts: [NFT]) {
        guard !nfts.isEmpty else {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }

                purchaseButtonContainerHeight?.constant = 0
                view.layoutSubviews()
            }

            return
        }

        nftCountLabel.text = "\(nfts.count) NFT"
        totalPriceLabel.text = String(format: "%.2f ETH", nfts.reduce(0, { $0 + $1.price }))

        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }

            purchaseButtonContainerHeight?.constant = 76
            view.layoutSubviews()
        }
    }

    func showRemoveNFTAlert(for preview: UIImage) {
        nftRemoveView.setNFTImagePreview(preview)

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.nftRemoveView.alpha = 1
        }
    }
}

extension ShoppingBagViewController: NFTRemoveViewDelegate {
    func didTapSubmitButton() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.nftRemoveView.alpha = 0
        }
    }

    func didTapCancelButton() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.nftRemoveView.alpha = 0
        }
    }
}

private extension ShoppingBagViewController {
    func setupNavBar() {
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "sortIcon"),
            style: .plain,
            target: self,
            action: #selector(didTapSortBarButtonItem)
        )
        rightBarButtonItem.tintColor = .black

        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            nftsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nftsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nftsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            purchaseContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            purchaseContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            purchaseContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            nftCountLabel.leadingAnchor.constraint(equalTo: purchaseContainer.leadingAnchor, constant: 16),
            nftCountLabel.topAnchor.constraint(equalTo: purchaseContainer.topAnchor, constant: 16),

            totalPriceLabel.leadingAnchor.constraint(equalTo: nftCountLabel.leadingAnchor),
            totalPriceLabel.topAnchor.constraint(equalTo: nftCountLabel.bottomAnchor, constant: 2),

            purchaseButton.topAnchor.constraint(equalTo: purchaseContainer.topAnchor, constant: 16),
            purchaseButton.trailingAnchor.constraint(equalTo: purchaseContainer.trailingAnchor, constant: -16),
            purchaseButton.bottomAnchor.constraint(equalTo: purchaseContainer.bottomAnchor, constant: -16),
            purchaseButton.widthAnchor.constraint(equalToConstant: 240)
        ])

        purchaseButtonContainerHeight = purchaseContainer.heightAnchor.constraint(equalToConstant: 0)
        purchaseButtonContainerHeight?.isActive = true
    }

    func setupNFTRemoveView() {
        nftRemoveView.delegate = self

        guard let rootView = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController?.view else {
            return
        }

        rootView.addSubview(nftRemoveView)

        NSLayoutConstraint.activate([
            nftRemoveView.topAnchor.constraint(equalTo: rootView.topAnchor),
            nftRemoveView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            nftRemoveView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            nftRemoveView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
        ])
    }

    @objc func didTapSortBarButtonItem() {
        output?.didTapSortButton()
    }

    @objc func didTapPurchaseButton() {
        output?.didTapPurchaseButton()
    }
}
