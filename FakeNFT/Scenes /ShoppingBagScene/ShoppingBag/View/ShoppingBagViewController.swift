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

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingBagAssembly.assemble(viewController: self)

        view.backgroundColor = .white

        setupNavBar()
        setupConstraints()

        output?.viewDidLoad()
    }

}

extension ShoppingBagViewController: ShoppingBagViewInput {
    func showProgressHUD() {
        UIBlockingProgressHUD.show()
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
    }

    @objc func didTapSortBarButtonItem() {
        print(#function)
    }
}
