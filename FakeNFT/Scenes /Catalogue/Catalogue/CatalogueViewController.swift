//
//  CatalogueViewController.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 10.10.2023.
//

import UIKit
import Kingfisher

protocol CatalogueViewControllerProtocol: AnyObject {
    var presenter: CataloguePresenterProtocol { get set }
    func updateTableView()
    func tableViewAddRows(indexPaths: [IndexPath])
}

final class CatalogueViewController: UIViewController, CatalogueViewControllerProtocol {
    
    // MARK: - Enums
    private enum Contstant {
        static let catalogueCellIdentifier = "CatalogueCell"
    }
    
    // MARK: - Public Properties
    var presenter: CataloguePresenterProtocol = CataloguePresenter()

    // MARK: - Private Properties
    private lazy var catalogueTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.register(CatalogueCell.self)
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
        
        setupScreen()
    }
    
    // MARK: - Public methods
    func tableViewAddRows(indexPaths: [IndexPath]) {
        catalogueTableView.performBatchUpdates {
            catalogueTableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func updateTableView() {
        catalogueTableView.reloadData()
    }
    
    // MARK: - Private methods
    private func setupScreen() {
        setupNavigationBar()
        addSubviews()
        contstraintSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(catalogueTableView)
    }
    
    private func contstraintSubviews() {
        NSLayoutConstraint.activate([
            catalogueTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            catalogueTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            catalogueTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            catalogueTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showFilterSheet))
        rightButton.tintColor = .black
        navigationBar.topItem?.setRightBarButton(rightButton, animated: true)
    }
    
    private func configCell(for cell: CatalogueCell, indexPath: IndexPath) {
        
        let collection = presenter.collections[indexPath.row]
        cell.picture.kf.setImage(with: collection.cover) { [weak self] _ in
            self?.catalogueTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.labelText.text = "\(collection.name) (\(collection.nfts.count))"
    }
    
    @objc
    private func showFilterSheet() {
        let alert = AlertPresenter(delegate: self)
        let sortByNameButton = UIAlertAction(title: "По названию", style: .default) { _ in
            self.presenter.filterCollections(.byName)
        }
        let sortByCountButton = UIAlertAction(title: "По количеству NFT", style: .default) { _ in
            self.presenter.filterCollections(.NFTcount)
        }
        let closeButton = UIAlertAction(title: "Закрыть", style: .cancel)
        let model = AlertModel(style: .actionSheet, title: "Сортировка", message: nil, actions: [sortByNameButton, sortByCountButton, closeButton])
        alert.show(result: model)
        
    }
}

// MARK: - UITableViewDelegate
extension CatalogueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (presenter.collections.count) - 1 {
            presenter.loadCollections()
        }
    }
}

// MARK: - UITableViewDataSource
extension CatalogueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatalogueCell = tableView.dequeueReusableCell()
        configCell(for: cell, indexPath: indexPath)
        return cell
    }
}
