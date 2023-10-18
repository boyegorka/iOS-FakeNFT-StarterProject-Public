//
//  CataloguePresenter.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 10.10.2023.
//

import Foundation

protocol CataloguePresenterProtocol {
    var view: CatalogueViewControllerProtocol? { get set }
    var collections: [NFTCollectionModel] { get }
    func viewDidLoad()
    func didTapFilterButton()
    func filterCollections()
    func willDisplayCell(_ indexPath: IndexPath)
    func setDataForUserDefaults(by type: Int, for key: String)
}

final class CataloguePresenter: CataloguePresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: CatalogueViewControllerProtocol?
    private (set) var collections: [NFTCollectionModel] = []
    static let didChangeCollectionsListNotification = Notification.Name(rawValue: "ChangeCollectionsList")
    
    // MARK: - Private Properties
    private let service = CatalogueService()
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Public methods
    func viewDidLoad() {
        UIBlockingProgressHUD.show()
        NotificationCenter.default
            .addObserver(forName: CataloguePresenter.didChangeCollectionsListNotification, object: nil, queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableView(animated: true)
                filterCollections()
                UIBlockingProgressHUD.dismiss()
            }
        loadCollections()
    }
    
    func filterCollections() {
        let filterTypeInt = userDefaults.integer(forKey: "CatalogueFilterType")
        let filterType = FilterType(rawValue: filterTypeInt)
        switch filterType { 
        case .byName:
            self.collections = collections.sorted(by: { $0.name < $1.name })
        case .NFTcount:
            self.collections = collections.sorted(by: { $0.nfts.count > $1.nfts.count })
        default:
            break
        }
        updateTableView(animated: false)
    }
    
    func didTapFilterButton() {
        filterCollections()
    }
    
    func willDisplayCell(_ indexPath: IndexPath) {
        if indexPath.row == (self.collections.count) - 1 {
            loadCollections()
        }
    }
    
    func setDataForUserDefaults(by type: Int, for key: String) {
        self.userDefaults.setValue(type, forKey: "CatalogueFilterType")
    }
    
    // MARK: - Private methods
    private func updateTableView(animated: Bool) {
        guard animated else {
            view?.updateTableView()
            return
        }
        let oldCount = collections.count
        let newCount = service.collections.count
        collections = service.collections
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { row in
                IndexPath(row: row, section: 0)
            }
            view?.tableViewAddRows(indexPaths: indexPaths)
        }
    }
    
    private func loadCollections() {
        service.loadCollections { [weak self] result in
            switch result {
            case .success(_):
                break
            case .failure(let errorForAlert):
                self?.view?.showErrorAlert(errorForAlert.localizedDescription)
            }
        }
    }
}

// MARK: - Enums
enum FilterType: Int {
    case byName
    case NFTcount
}
