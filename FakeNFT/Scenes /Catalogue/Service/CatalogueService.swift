//
//  CatalogueService.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 11.10.2023.
//

import Foundation

class CatalogueService {

    // MARK: - Public Properties

    let baseUrl = "https://651ff00f906e276284c3bfac.mockapi.io"
    var collections: [NFTCollectionModel] = []
    
    // MARK: - Private Properties
    private let networkClient = DefaultNetworkClient()
    private var lastCollectionsLenght: Int = 0
    private var lastLoadedPage: Int = 0
    
    // MARK: - Public methods
    func loadCollections() {
        lastCollectionsLenght = collections.count
        
        let nextPage = lastLoadedPage + 1
        
        let url = URL(string: "https://651ff00f906e276284c3bfac.mockapi.io/api/v1/collections?page=\(nextPage)&limit=10")

        networkClient.send(request: CollectionsRequest(endpoint: url, httpMethod: .get),
                           type: [NFTCollectionResult].self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.lastLoadedPage = nextPage
                    self.collections.append(contentsOf: data.map({ NFTCollectionModel(collectionResult: $0) }))
                    NotificationCenter.default
                        .post(name: CataloguePresenter.didChangeCollectionsListNotification, object: self)
                }
            case .failure(let error):
                print(error)
            }
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
