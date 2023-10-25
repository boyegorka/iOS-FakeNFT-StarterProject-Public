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
    let userId: String = "1"
    
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
        
        networkClient.send(request: CatalogueRequest(endpoint: url),
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
        
        networkClient.send(request: CatalogueRequest(endpoint: url), type: UserResult.self) { result in
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
    
    func loadNFTS(_ ids: [String], completion: @escaping (Result<[NFTModel], Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/api/v1/nft")
        
        networkClient.send(request: CatalogueRequest(endpoint: url), type: [NFT].self) { result in
            switch result {
            case .success(let data):
                let filterData = data.filter{ ids.contains($0.id) }.map{ NFTModel(nft: $0) }
                DispatchQueue.main.async {
                    completion(.success(filterData))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func loadProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/api/v1/profile/\(userId)")
        
        networkClient.send(request: CatalogueRequest(endpoint: url), type: ProfileResult.self) { result in
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
        let url = URL(string: "\(baseUrl)/api/v1/orders/\(userId)")
        
        networkClient.send(request: CatalogueRequest(endpoint: url), type: CartResult.self) { result in
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
    
    func uploadLikes(likes: [String], completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/api/v1/profile/\(userId)")
        
        networkClient.send(request: CatalogueRequest(endpoint: url, httpMethod: .put, dto: LikesDTO(likes: likes)), type: ProfileResult.self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let profile = ProfileModel(profileResult: data)
                    completion(.success(profile))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadOrders(orders: [String], completion: @escaping (Result<CartModel, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/api/v1/orders/\(userId)")
        
        networkClient.send(request: CatalogueRequest(endpoint: url, httpMethod: .put, dto: OrdersDTO(nfts: orders)), type: CartResult.self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let cart = CartModel(cartResult: data)
                    completion(.success(cart))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Structs
    struct CatalogueRequest: NetworkRequest {
        var endpoint: URL?
        var httpMethod: HttpMethod
        var dto: Encodable?
        
        init(endpoint: URL? = nil, httpMethod: HttpMethod = .get, dto: Encodable? = nil) {
            self.endpoint = endpoint
            self.httpMethod = httpMethod
            self.dto = dto
        }
    }
}
