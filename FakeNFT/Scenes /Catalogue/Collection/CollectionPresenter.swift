//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 18.10.2023.
//

import Foundation

protocol CollectionPresenterProtocol {
    var view: CollectionViewControllerProtocol? { get }
    var collection: NFTCollectionModel { get }
    var authorProfile: UserModel? { get }
    var nfts: [NFTModel] { get }
    func viewDidLoad()
    func isLikedNFT(_ id: String) -> Bool
    func isInCart(_ id: String) -> Bool
}

final class CollectionPresenter: CollectionPresenterProtocol {
    
    let collection: NFTCollectionModel
    var nfts: [NFTModel] = []
    var likes: [String] = []
    var orders: [String] = []
    var authorProfile: UserModel? = nil
    
    weak var view: CollectionViewControllerProtocol?
    
    private var showError: Bool = false
    private let service = CatalogueService()
    
    init(collection: NFTCollectionModel) {
        self.collection = collection
    }
    
    func viewDidLoad() {
        UIBlockingProgressHUD.show()
        showError = false
        
        let group = DispatchGroup()
        
        group.enter()
        loadCollectionAuthor {
            group.leave()
        }
        
        group.enter()
        loadLikes {
            group.leave()
        }
        
        group.enter()
        loadOrders {
            group.leave()
        }
        
        group.enter()
        loadNFTS {
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main, execute: { [weak self] in
            guard let self else { return }
            if self.showError {
                view?.showErrorAlert("Ошибка загрузки. Повторить?")
            } else {
                view?.updateData()
            }
            UIBlockingProgressHUD.dismiss()
        })
    }
    
    func loadNFTS(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        nfts = []
        
        for id in collection.nfts {
            group.enter()
            service.loadNFT(id) { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nfts.append(nft)
                case .failure(let error):
                    print(error)
                    self?.showError = true
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            completion()
        })
    }
    
    func loadCollectionAuthor(completion: @escaping () -> Void) {
        service.loadUser(collection.id) { [weak self] result in
            switch result {
            case .success(let user):
                self?.authorProfile = user
            case .failure(let error):
                print(error)
                self?.showError = true
            }
            completion()
        }
    }
    
    func loadLikes(completion: @escaping () -> Void) {
        service.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.likes = profile.likes
            case .failure(let error):
                self?.showError = true
                print(error)
            }
            completion()
        }
    }
    
    func loadOrders(completion: @escaping () -> Void) {
        service.loadCart { [weak self] result in
            switch result {
            case .success(let cart):
                self?.orders = cart.nfts
            case .failure(let error):
                self?.showError = true
                print(error)
            }
            completion()
        }
    }
    
    func isLikedNFT(_ id: String) -> Bool {
        likes.contains(id)
    }
    
    func isInCart(_ id: String) -> Bool {
        orders.contains(id)
    }
}
