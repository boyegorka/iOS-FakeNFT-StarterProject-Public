//
//  NFTService.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 21.10.2023.
//

import Foundation

protocol NFTServiceProtocol {
    func getNFT(id: String, _ handler: @escaping(Result<NFT, Error>) -> Void)
}

struct GetNFTRequest: NetworkRequest {
    private let path = "/api/v1/nft"
    var endpoint: URL?
    
    init(nftID: String) {
        guard let url = URL(string: "\(path)/\(nftID)", relativeTo: baseURL) else {
            assertionFailure("failed to create url from \(String(describing: baseURL)) and path: \(path)")
            return
        }
        
        endpoint = url
    }
}

final class NFTService: NFTServiceProtocol {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getNFT(id: String, _ handler: @escaping (Result<NFT, Error>) -> Void) {
        let req = GetNFTRequest(nftID: id)
        
        networkClient.send(request: req, type: NFT.self) { (result: Result<NFT, Error>) in
            handler(result)
        }
    }
}
