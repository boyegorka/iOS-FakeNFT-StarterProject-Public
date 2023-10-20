//
//  ShoppingBagRouter.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 11.10.2023.
//

import UIKit

protocol ShoppingBagRouter {
    func presentSortTypePickerAlert()
    func presentPaymentTypePicker(moduleOutput: ShoppingBagPaymentPickerModuleOutput)
    func hidePaymentTypePicker()
    func presentPaymentResults(moduleOutput: ShoppingBagPaymentResultsModuleOutput)
    func hidePaymentResults()
}

protocol ShoppingBagRouterOutput: AnyObject {
    func didSelectSortType(_ sortType: ShoppingBagSortType)
}

final class ShoppingBagRouterImpl {
    weak var viewController: UIViewController?
    weak var output: ShoppingBagRouterOutput?
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

    func presentPaymentTypePicker(moduleOutput: ShoppingBagPaymentPickerModuleOutput) {
        let paymentPickerViewController = ShoppingBagPaymentPickerAssembly.assemble(moduleOutput: moduleOutput)
        viewController?.navigationController?.pushViewController(paymentPickerViewController, animated: true)
    }

    func hidePaymentTypePicker() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func presentPaymentResults(moduleOutput: ShoppingBagPaymentResultsModuleOutput) {
        let paymentResultsViewController = ShoppingBagPaymentResultsAssembly.assemble(moduleOutput: moduleOutput)
        viewController?.navigationController?.pushViewController(paymentResultsViewController, animated: true)
    }

    func hidePaymentResults() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
