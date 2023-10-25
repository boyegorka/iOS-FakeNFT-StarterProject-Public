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
    func setLikeForNFT(_ id: String)
    func addNFTToCart(_ id: String)
}

final class CollectionPresenter: CollectionPresenterProtocol {
    
    // MARK: - Public Properties
    let collection: NFTCollectionModel
    var nfts: [NFTModel] = []
    var likes: [String] = []
    var orders: [String] = []
    var authorProfile: UserModel? = nil
    
    weak var view: CollectionViewControllerProtocol?
    
    // MARK: - Private Properties
    private var showError: Bool = false
    private let service = CatalogueService()
    
    // MARK: - Lifecycle
    init(collection: NFTCollectionModel) {
        self.collection = collection
    }
    
    // MARK: - Public methods
    @objc
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
                view?.showErrorAlert("Ошибка загрузки. Повторить?", repeatAction: #selector(viewDidLoad), target: self)
            } else {
                view?.updateData()
            }
            UIBlockingProgressHUD.dismiss()
        })
    }
    
    func loadNFTS(completion: @escaping () -> Void) {
        service.loadNFTS(collection.nfts) { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.nfts = nfts
            case .failure(let error):
                print(error)
                self?.showError = true
            }
            completion()
        }
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
    
    @objc
    func uploadLikes() {
        UIBlockingProgressHUD.show()
        service.uploadLikes(likes: self.likes) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.likes = profile.likes
                self?.view?.updateData()
            case .failure(let error):
                print(error)
                self?.view?.showErrorAlert("Не удалось поставить лайк", repeatAction: #selector(self?.uploadLikes), target: self)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    @objc
    func uploadCart() {
        UIBlockingProgressHUD.show()
        service.uploadOrders(orders: orders) { [weak self] result in
            switch result {
            case .success(let cart):
                self?.orders = cart.nfts
                self?.view?.updateData()
            case .failure(let error):
                print(error)
                self?.view?.showErrorAlert("Не удалось добавить в корзину", repeatAction: #selector(self?.uploadCart), target: self)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func setLikeForNFT(_ id: String) {
        if isLikedNFT(id) {
            guard let likeToDelete = likes.firstIndex(of: id) else { return }
            likes.remove(at: likeToDelete)
        } else {
            likes.append(id)
        }
        
        uploadLikes()
    }
    
    func addNFTToCart(_ id: String) {
        if isInCart(id) {
            guard let ordersToDelete = orders.firstIndex(of: id) else { return }
            orders.remove(at: ordersToDelete)
        } else {
            orders.append(id)
        }
        
        uploadCart()
    }
    
    func isLikedNFT(_ id: String) -> Bool {
        likes.contains(id)
    }
    
    func isInCart(_ id: String) -> Bool {
        orders.contains(id)
    }
}
