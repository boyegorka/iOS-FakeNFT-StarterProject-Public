//
//  RatingViewController.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 09.10.2023.
//

import Foundation
import UIKit
import Kingfisher

let horizontalPadding: CGFloat = 16
let rowHeight: CGFloat = 88

let unknownAvatar = UIImage(systemName: "person.crop.circle.fill")

protocol RatingViewPresenterProtocol: AnyObject {
    var users: [User] { get }
    
    func setDelegate(delegate: RatingViewPresenterDelegate)
    func listUsers()
    
    func setSortParameter(_ sortParameter: UsersSortParameter)
    func setSortOrder(_ sortOrder: UsersSortOrder)
}

final class RatingViewController: UIViewController {
    private let cellIdentifier = "cell"
    
    lazy private var presenter: RatingViewPresenterProtocol = {
        let defaultNetworkClient = DefaultNetworkClient()
        presenter = RatingViewPresenter(networkClient: defaultNetworkClient)
        presenter.setDelegate(delegate: self)
        return presenter
    }()
    
    lazy private var sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "sortIcon"), for: .normal)
        button.backgroundColor = .background
        
        button.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy private var table: UITableView = {
        let table = UITableView()
        table.rowHeight = rowHeight
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .background
        
        table.dataSource = self
        table.delegate = self
        
        table.register(RatingCell.self, forCellReuseIdentifier: cellIdentifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sortButton)
        view.addSubview(table)
        
        setupConstraints()
        presenter.listUsers()
    }
            
    func setupConstraints() {
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            
            table.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension RatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.users.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.users.count - 1 {
            presenter.listUsers()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RatingCell()
        
        configCell(for: cell, with: indexPath)
        return cell
    }
    
    func configCell(for userCell: RatingCell, with indexPath: IndexPath) {
        if indexPath.row >= presenter.users.count {
            assertionFailure("configCell: indexPath.row >= users.count")
            return
        }

        let imageView = UIImageView()
        
        do {
            try loadImage(
                to: imageView,
                url: presenter.users[indexPath.row].avatarUrl
            ) { [weak self] result in
                guard let self = self else {
                    assertionFailure("load image: self is empty")
                    return
                }
                
                switch result {
                case .success(_):
                    self.table.reloadRows(at: [indexPath], with: .automatic)
                 case .failure(let error):
                    self.showAlert(msg: NSLocalizedString("alert.general.message", comment: ""))
                    print("load image failed with error: \(error)")
                    return
                }
            }
        }
        catch {
            print("load image failed with error: \(error)")
            return
        }
        
        userCell.configure(
            ratingPosition: indexPath.row + 1,
            name: presenter.users[indexPath.row].name,
            avatar: imageView.image ?? unknownAvatar!,
            rating: presenter.users[indexPath.row].rating
        )
    }
}

extension RatingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension RatingViewController: RatingViewPresenterDelegate {
    func loadUserStarted() {
        UIBlockingProgressHUD.show()
    }
    
    func loadUserFinished() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("alert.title", comment: ""),
            message: msg,
            preferredStyle: .alert
        )
        
        let actionExit = UIAlertAction(
            title: NSLocalizedString("alert.close", comment: ""),
            style: .default
        ) { _ in }
        
        alert.addAction(actionExit)
        
        present(alert, animated: true)
    }
    
    func performBatchUpdates(indexPaths: [IndexPath]) {
        table.performBatchUpdates {
            self.table.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func reloadData() {
        table.reloadData()
        if table.numberOfRows(inSection: 0) != 0 {
            table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

extension RatingViewController {
    @objc func didTapSortButton() {
        let nameSort = UIAlertAction(
            title: NSLocalizedString("sort.byname", tableName: "RatingScreen", comment: ""),
            style: .destructive
        ) { [weak self] _ in
            guard let self = self else {
                assertionFailure("didTapSortButton: self is empty")
                return
            }

            self.presenter.setSortParameter(UsersSortParameter.byName)
            self.presenter.setSortOrder(UsersSortOrder.asc)
            
            self.presenter.listUsers()
        }
        
        let ratingSort = UIAlertAction(
            title: NSLocalizedString("sort.byrating", tableName: "RatingScreen", comment: ""),
            style: .destructive
        ) { [weak self] _ in
            guard let self = self else {
                assertionFailure("didTapSortButton: self is empty")
                return
            }

            self.presenter.setSortParameter(UsersSortParameter.byRating)
            self.presenter.setSortOrder(UsersSortOrder.asc)
            
            self.presenter.listUsers()
        }
        
        let cancel = UIAlertAction(
            title: NSLocalizedString("sort.close", tableName: "RatingScreen", comment: ""),
            style: .cancel
        )
        
        let alert = UIAlertController(
            title: NSLocalizedString("sort.title", tableName: "RatingScreen", comment: ""),
            message: "",
            preferredStyle: .actionSheet)
        
        alert.addAction(nameSort)
        alert.addAction(ratingSort)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}

extension RatingViewController {
    private func loadImage(
        to imageView: UIImageView,
        url: String,
        handler: @escaping(Result<RetrieveImageResult, KingfisherError>) -> Void
    ) throws {
        guard let avatarURL = URL(string: url) else {
            print("failed to create URL from \(url)")
            imageView.image = unknownAvatar
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        
        imageView.kf.setImage(
            with: avatarURL,
            placeholder: unknownAvatar,
            options: [.processor(processor)],
            completionHandler: {result in
                handler(result)
            }
        )
    }
}
