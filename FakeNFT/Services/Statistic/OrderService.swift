//
//  CartService.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 26.10.2023.
//

import Foundation

protocol OrderServiceProtocol {
    func getOrder(orderID: String, _ handler: @escaping(Result<ShoppingOrder, Error>) -> Void)
    func updateOrder(updateOrder: ShoppingOrder, _ handler: @escaping(Result<ShoppingOrder, Error>) -> Void)
}

struct GetOrderRequest: NetworkRequest {
    private var path = "/api/v1/orders"
    
    var endpoint: URL?
    
    init(orderID: String) {
        guard let url = URL(string: "\(path)/\(orderID)", relativeTo: baseURL) else {
            assertionFailure("failed to create url from baseURL: \(String(describing: baseURL?.absoluteString)), path: \(path)")
            return
        }
        
        self.endpoint = url
    }
}

struct UpdateOrderRequest: NetworkRequest {
    private var path = "/api/v1/orders"
    
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Encodable?
    
    init(updateOrder: ShoppingOrder) {
        self.httpMethod = .put
        self.dto = updateOrder
        
        guard let url = URL(string: "\(path)/\(updateOrder.id)", relativeTo: baseURL) else {
            assertionFailure("failed to create url from baseURL: \(String(describing: baseURL?.absoluteString)), path: \(path)")
            return
        }
        
        self.endpoint = url
    }
}

final class OrderService: OrderServiceProtocol {
    let networkClient: NetworkClient
    
    private var updateOrderDataTask: NetworkTask?
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getOrder(orderID: String, _ handler: @escaping (Result<ShoppingOrder, Error>) -> Void) {
        let req = GetOrderRequest(orderID: orderID)
        
        networkClient.send(request: req, type: ShoppingOrder.self) { (result: Result<ShoppingOrder, Error>) in
            handler(result)
        }
    }
    
    func updateOrder(updateOrder: ShoppingOrder, _ handler: @escaping (Result<ShoppingOrder, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if updateOrderDataTask != nil {
            return
        }
        
        let req = UpdateOrderRequest(updateOrder: updateOrder)
        
        updateOrderDataTask = networkClient.send(request: req, type: ShoppingOrder.self) { [weak self] (result: Result<ShoppingOrder, Error>) in
            guard let self = self else {
                assertionFailure("updateProfile: self is empty")
                return
            }

            self.updateOrderDataTask = nil
            handler(result)
        }
    }
}
