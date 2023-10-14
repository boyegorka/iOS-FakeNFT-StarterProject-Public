//
//  ShoppingBagDataSource.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import UIKit

final class ShoppingBagDataSource: NSObject {
    weak var module: ShoppingBagModule?
}

extension ShoppingBagDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        module?.numberOfNFTs ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderCell = tableView.dequeueReusableCell()

        guard let cellModel = module?.nftCellModels[indexPath.row] else {
            return UITableViewCell()
        }

        cell.configure(from: cellModel)

        return cell
    }
}
