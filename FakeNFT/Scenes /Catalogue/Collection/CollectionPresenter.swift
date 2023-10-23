//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 18.10.2023.
//

import Foundation

protocol CollectionPresenterProtocol {
    var view: CollectionViewControllerProtocol? { get }
}

final class CollectionPresenter: CollectionPresenterProtocol {
    
    weak var view: CollectionViewControllerProtocol?
    
    
}
