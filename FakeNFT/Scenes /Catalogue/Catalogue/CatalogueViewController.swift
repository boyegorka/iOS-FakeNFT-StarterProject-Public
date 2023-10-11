//
//  CatalogueViewController.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 10.10.2023.
//

import UIKit

final class CatalogueViewController: UIViewController {
    
    
    // MARK: - Enums
    private enum Contstant {
        static let catalogueCellIdentifier = "CatalogueCell"
    }
    
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
        tableView.register(CatalogueCell.self, forCellReuseIdentifier: Contstant.catalogueCellIdentifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
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
    
    @objc
    private func showFilterSheet() {
        let alert = AlertPresenter(delegate: self)
        let sortByNameButton = UIAlertAction(title: "По названию", style: .default) { _ in
            
        }
        let sortByCountButton = UIAlertAction(title: "По количеству NFT", style: .default) { _ in
            
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
}

// MARK: - UITableViewDataSource
extension CatalogueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Contstant.catalogueCellIdentifier) as? CatalogueCell
        else { return UITableViewCell() }
        
        cell.picture = UIImage()
        cell.labelText = "Коллекция (число элементов)"
        
        return cell
    }
}
