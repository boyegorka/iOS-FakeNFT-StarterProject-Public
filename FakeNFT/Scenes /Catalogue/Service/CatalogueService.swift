//
//  CatalogueService.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 11.10.2023.
//

import Foundation

final class CatalogueService {

    // MARK: - Public Properties

    let baseUrl = "https://651ff00f906e276284c3bfac.mockapi.io"
    var collections: [NFTCollectionModel] = []
    
    // MARK: - Private Properties
    private let networkClient = DefaultNetworkClient()
    private var lastLoadedPage: Int = 0
    private var isLoading: Bool = false
    private let limitForLoadind = 10
    private var allDownloaded: Bool = false
    
    // MARK: - Public methods
    func loadCollections(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard !isLoading, !allDownloaded else { return }
        
        let nextPage = lastLoadedPage + 1
        
        let url = URL(string: "\(baseUrl)/api/v1/collections?page=\(nextPage)&limit=\(limitForLoadind)")
        
        self.isLoading = true
        
        networkClient.send(request: CatalogueGetRequest(endpoint: url),
                           type: [NFTCollectionResult].self) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.lastLoadedPage = nextPage
                    let collectionsResult = data.map({NFTCollectionModel(collectionResult: $0)})
                    if collectionsResult.count < self?.limitForLoadind ?? 0 {
                        self?.allDownloaded = true
                    }
                    self?.collections.append(contentsOf: collectionsResult)
                    completion(.success(true))
                    NotificationCenter.default
                        .post(name: CataloguePresenter.didChangeCollectionsListNotification, object: self)
                }
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
            self?.isLoading = false
        }
    }
    
    func loadUser(_ id: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/api/v1/users/\(id)")
        
        networkClient.send(request: CatalogueGetRequest(endpoint: url), type: UserResult.self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let authorProfile = UserModel(userResult: data)
                    completion(.success(authorProfile))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func loadNFT(_ id: String, completion: @escaping (Result<NFTModel, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/api/v1/nft/\(id)")
        
        networkClient.send(request: CatalogueGetRequest(endpoint: url), type: NFT.self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let nft = NFTModel(nft: data)
                    completion(.success(nft))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func loadProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/api/v1/profile/1")
        
        networkClient.send(request: CatalogueGetRequest(endpoint: url), type: ProfileResult.self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let profile = ProfileModel(profileResult: data)
                    completion(.success(profile))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func loadCart(completion: @escaping (Result<CartModel, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/api/v1/orders/1")
        
        networkClient.send(request: CatalogueGetRequest(endpoint: url), type: CartResult.self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let cart = CartModel(cartResult: data)
                    completion(.success(cart))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func uploadLikes() {
        
    }
    
    func uploadOrders() {
        
    }
    
    // MARK: - Structs
    struct CatalogueGetRequest: NetworkRequest {
        var endpoint: URL?
        
        init(endpoint: URL? = nil) {
            self.endpoint = endpoint
        }
    }
}
