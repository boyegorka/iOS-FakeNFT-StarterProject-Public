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

    func setDataSource(_ dataSource: UITableViewDataSource) {
        nftsTableView.dataSource = dataSource
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingBagAssembly.assemble(viewController: self)

        nftsTableView.register(OrderCell.self)

        view.backgroundColor = .background

        view.addSubview(nftsTableView)

        setupNavBar()
        setupConstraints()

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
            nftsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func didTapSortBarButtonItem() {
        print(#function)
    }
}
