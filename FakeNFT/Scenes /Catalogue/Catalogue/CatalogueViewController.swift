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
    func showErrorAlert(_ message: String)
}

final class CatalogueViewController: UIViewController, CatalogueViewControllerProtocol {
    
    // MARK: - Public Properties
    var presenter: CataloguePresenterProtocol = CataloguePresenter()

    // MARK: - Private Properties
    private lazy var catalogueTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .ypWhite
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
    
    func showErrorAlert(_ message: String) {
        let actionOK = UIAlertAction(title: "OK", style: .default) { _ in }
        let viewModel = AlertModel(style: .alert, title: "Что-то пошло не так", message: message, actions: [actionOK])
        let presenter = AlertPresenter(delegate: self)
        presenter.show(result: viewModel)
    }
    
    // MARK: - Private methods
    private func setupScreen() {
        view.backgroundColor = .ypWhite
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
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "sortIcon"), style: .plain, target: self, action: #selector(showFilterSheet))
        rightButton.tintColor = .ypBlack
        navigationBar.topItem?.setRightBarButton(rightButton, animated: true)
    }
    
    private func configCell(for cell: CatalogueCell, indexPath: IndexPath) {
        let collection = presenter.collections[indexPath.row]
        cell.picture.kf.indicatorType = .activity
        cell.picture.kf.setImage(with: collection.cover)
        cell.labelText.text = "\(collection.name) (\(collection.nfts.count))"
    }
    
    private func showCollectionInfo(for collection: NFTCollectionModel) {
        let vc = CollectionViewController()
        let presenter = CollectionPresenter(collection: collection)
        
        vc.presenter = presenter
        presenter.view = vc
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func showFilterSheet() {
        let alert = AlertPresenter(delegate: self)
        let sortByNameButton = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.presenter.setDataForUserDefaults(by: FilterType.byName.rawValue, for: "CatalogueFilterType")
            self?.presenter.didTapFilterButton()
        }
        let sortByCountButton = UIAlertAction(title: "По количеству NFT", style: .default) { [weak self] _ in
            self?.presenter.setDataForUserDefaults(by: FilterType.NFTcount.rawValue, for: "CatalogueFilterType")
            self?.presenter.didTapFilterButton()
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
        presenter.willDisplayCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showCollectionInfo(for: presenter.collections[indexPath.row])
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
