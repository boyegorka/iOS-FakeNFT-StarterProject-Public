//
//  RatingViewPresenter.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 10.10.2023.
//

import Foundation

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
    func reloadData()
    
    func loadUserStarted()
    func loadUserFinished()
}

final class RatingViewPresenter: RatingViewPresenterProtocol {
    private let usersPerPage = 20
    private let sortParameterKey = "sortParameter"
    private let sortOrderKey = "sortOrderKey"
    
    private var lastLoadedPage = 0
    private var sortParameter: UsersSortParameter
    private var sortOrder: UsersSortOrder
    
    private var service: UserServiceProtocol
    
    weak var delegate: RatingViewPresenterDelegate?
    
    var users: [User] = []

    init(networkClient: NetworkClient) {
        switch UserDefaults.standard.string(forKey: sortParameterKey) {
        case UsersSortParameter.byRating.rawValue:
            sortParameter = UsersSortParameter.byRating
        case UsersSortParameter.byName.rawValue:
            sortParameter = UsersSortParameter.byName
        default:
            print("failed to get sortParameter from userDefaults")
            sortParameter = UsersSortParameter.byRating
        }
    
        switch UserDefaults.standard.string(forKey: sortOrderKey) {
        case UsersSortOrder.asc.rawValue:
            sortOrder = UsersSortOrder.asc
        case UsersSortOrder.desc.rawValue:
            sortOrder = UsersSortOrder.desc
        default:
            print("failed to get sortOrder from userDefaults")
            sortOrder = UsersSortOrder.asc
        }

        self.service = UserService(networkClient: networkClient)
    }
        
    func setDelegate(delegate: RatingViewPresenterDelegate) {
        self.delegate = delegate
    }
    
    func listUsers() {
        assert(Thread.isMainThread)
            
        let nextPage = lastLoadedPage + 1
        
        delegate?.loadUserStarted()
        
        service.listUser(
            usersPerPage: usersPerPage,
            nextPage: nextPage,
            sortParameter: sortParameter,
            sortOrder: sortOrder
        ) { [weak self] (result: Result<[User], Error>) in
            DispatchQueue.main.async {
                guard let self = self else {
                    assertionFailure("send request: self is empty")
                    return
                }
                
                self.delegate?.loadUserFinished()
                
                switch result {
                case .failure(let error):
                    if let delegate = self.delegate {
                        print("list users failed: \(error)")
                        delegate.showAlert(
                            msg: NSLocalizedString("alert.message", tableName: "RatingScreen", comment: "")
                        )
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
        if lastLoadedPage == 1 {
            delegate?.reloadData()
            return
        }
        
        let startIndex = users.count - newUsers.count
        let endIndex = startIndex + newUsers.count
        let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        
        delegate?.performBatchUpdates(indexPaths: indexPaths)
    }
    
    func setSortParameter(_ sortParameter: UsersSortParameter) {
        self.sortParameter = sortParameter
        UserDefaults.standard.set(sortParameter.rawValue, forKey: sortParameterKey)
        
        lastLoadedPage = 0
        users = []
    }
    
    func setSortOrder(_ sortOrder: UsersSortOrder) {
        self.sortOrder = sortOrder
        UserDefaults.standard.set(sortOrder.rawValue, forKey: sortOrderKey)
    }
}
