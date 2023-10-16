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
    func loadCollections()
    func viewDidLoad()
    func filterCollections(_ filterType: FilterType)
}

final class CataloguePresenter: CataloguePresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: CatalogueViewControllerProtocol?
    private (set) var collections: [NFTCollectionModel] = []
    static let didChangeCollectionsListNotification = Notification.Name(rawValue: "ChangeCollectionsList")
    
    // MARK: - Private Properties
    private let service = CatalogueService()
    
    // MARK: - Public methods
    func viewDidLoad() {
        UIBlockingProgressHUD.show()
        NotificationCenter.default
            .addObserver(forName: CataloguePresenter.didChangeCollectionsListNotification, object: nil, queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableView(animated: true)
                UIBlockingProgressHUD.dismiss()
            }
        loadCollections()
    }
    
    func loadCollections() {
        service.loadCollections()
    }
    
    func filterCollections(_ filterType: FilterType) {
        switch filterType {
        case .byName:
            self.collections = collections.sorted(by: { $0.name < $1.name })
            updateTableView(animated: false)
        case .NFTcount:
            self.collections = collections.sorted(by: { $0.nfts.count > $1.nfts.count })
            updateTableView(animated: false)
        }
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
}

// MARK: - Enums
enum FilterType {
    case byName
    case NFTcount
}
