//
//  ShoppingBagRouter.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 11.10.2023.
//

import UIKit

protocol ShoppingBagRouter {
    func presentSortTypePickerAlert()
    func presentPaymentTypePicker()
}

protocol ShoppingBagRouterOutput {
    func didSelectSortType(_ sortType: ShoppingBagSortType)
}

final class ShoppingBagRouterImpl {
    var viewController: UIViewController?
    var output: ShoppingBagRouterOutput?
}

extension ShoppingBagRouterImpl: ShoppingBagRouter {
    func presentSortTypePickerAlert() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        let priceSortAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.output?.didSelectSortType(.price)
        }

        let ratingSortAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.output?.didSelectSortType(.rating)
        }

        let nameSortAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.output?.didSelectSortType(.name)
        }

        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)

        alertController.addAction(priceSortAction)
        alertController.addAction(ratingSortAction)
        alertController.addAction(nameSortAction)
        alertController.addAction(cancelAction)
        viewController?.present(alertController, animated: true)
    }

    func presentPaymentTypePicker() {
        let paymentPickerViewController = ShoppingBagPaymentPicker()
        viewController?.navigationController?.pushViewController(paymentPickerViewController, animated: true)
    }
}
