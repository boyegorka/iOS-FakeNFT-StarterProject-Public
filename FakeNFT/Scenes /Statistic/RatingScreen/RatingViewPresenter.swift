//
//  RatingViewPresenter.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 10.10.2023.
//

import Foundation

let usersPerPage = 20

enum ListUserError: Error {
    case unknownError
}

enum UsersSortParameter: String {
    case byName = "name"
    case byRating = "rating"
}

enum UsersSortOrder: String {
    case asc = "asc"
    case desc = "desc"
}

protocol RatingViewPresenterDelegate: AnyObject {
    func showAlert(msg: String)
    func performBatchUpdates(indexPaths: [IndexPath])
    
    func loadUserStarted()
    func loadUserFinished()
}

struct ListUsersRequest: NetworkRequest {
    var endpoint: URL?
    
    init(nextPage: Int, usersPerPage: Int, sortParameter: UsersSortParameter, sortOrder: UsersSortOrder) {
        endpoint = URL(string: "https://651ff00f906e276284c3bfac.mockapi.io/api/v1/users" + "?sortBy=\(sortParameter)&order=\(sortOrder)&page=\(nextPage)&limit=\(usersPerPage)")
    }
}

final class RatingViewPresenter: RatingViewPresenterProtocol {
    weak var delegate: RatingViewPresenterDelegate?
    
    let networkClient: NetworkClient
    
    var users: [User] = []
    
    private var lastLoadedPage = 0
    private var sortParameter = UsersSortParameter.byRating
    private var sortOrder = UsersSortOrder.asc
    
    private var dataTask: NetworkTask?
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    deinit {
        print("presenter deinit")
    }
    
    func setDelegate(delegate: RatingViewPresenterDelegate) {
        self.delegate = delegate
    }
    
    func listUsers(sortParameter: UsersSortParameter, sortOrder: UsersSortOrder) {
        assert(Thread.isMainThread)
    
        if dataTask != nil {
            return
        }
                
        self.sortParameter = sortParameter
        self.sortOrder = sortOrder
        
        let nextPage = lastLoadedPage + 1
        let req = ListUsersRequest(
            nextPage: nextPage,
            usersPerPage: usersPerPage,
            sortParameter: sortParameter,
            sortOrder: sortOrder
        )
     
        let nc = DefaultNetworkClient()
        
        delegate?.loadUserStarted()
        dataTask = nc.send(request: req, type: [User].self) { (result: Result<[User], Error>) in
            DispatchQueue.main.async {
                self.delegate?.loadUserFinished()
                self.dataTask = nil
                
                switch result {
                case .failure(let error):
                    if let delegate = self.delegate {
                        delegate.showAlert(msg: "list users failed: \(error)")
                    }
                case .success(let newUsers):
                    self.lastLoadedPage = nextPage
                    self.users.append(contentsOf: newUsers)
                    
                    self.updateTableViewAnimated(newUsers)
                }
            }
        }
    }
    
    func updateTableViewAnimated(_ newUsers: [User]) {
        let startIndex = users.count - newUsers.count
        let endIndex = startIndex + newUsers.count
        let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        
        delegate?.performBatchUpdates(indexPaths: indexPaths)
    }
}
