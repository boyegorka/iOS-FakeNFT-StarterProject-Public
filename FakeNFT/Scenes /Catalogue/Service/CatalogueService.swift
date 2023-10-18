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
        
        networkClient.send(request: CollectionsRequest(endpoint: url, httpMethod: .get),
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
    
    // MARK: - Structs
    struct CollectionsRequest: NetworkRequest {
        var endpoint: URL?
        var httpMethod: HttpMethod
        var dto: Encodable?
        
        init(endpoint: URL? = nil, httpMethod: HttpMethod, dto: Encodable? = nil) {
            self.endpoint = endpoint
            self.httpMethod = httpMethod
            self.dto = dto
        }
    }
}
