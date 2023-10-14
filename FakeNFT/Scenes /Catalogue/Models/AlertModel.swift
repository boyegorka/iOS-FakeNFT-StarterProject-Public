//
//  AlertModel.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 11.10.2023.
//

import UIKit

struct AlertModel {
    var style: UIAlertController.Style
    var title: String
    var message: String?
    var actions: [UIAlertAction]
}
