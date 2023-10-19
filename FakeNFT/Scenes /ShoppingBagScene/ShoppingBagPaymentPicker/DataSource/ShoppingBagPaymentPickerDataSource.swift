//
//  ShoppingBagPaymentPickerDataSource.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 16.10.2023.
//

import UIKit

final class ShoppingBagPaymentPickerDataSource: NSObject {
    weak var module: ShoppingBagPaymentPickerModule?
}

extension ShoppingBagPaymentPickerDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        module?.numberOfCurrencies ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CurrencyCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        guard let cellModel = module?.cellModels[indexPath.row] else { return UICollectionViewCell() }

        cell.configure(from: cellModel)

        return cell
    }
}
