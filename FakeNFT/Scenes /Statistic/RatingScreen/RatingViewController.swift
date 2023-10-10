//
//  RatingViewController.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 09.10.2023.
//

import Foundation
import UIKit

let horizontalPadding: CGFloat = 16
let rowHeight: CGFloat = 88

final class RatingViewController: UIViewController {
    private let cellIdentifier = "cell"
    
    lazy private var sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "sort"), for: .normal)
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
        
        table.register(RatingViewControllerCell.self, forCellReuseIdentifier: cellIdentifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sortButton)
        view.addSubview(table)
        
        setupConstraints()
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
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
        ])
    }
    
    @objc func didTapSortButton() {
        let nameSort = UIAlertAction(
            //TODO: add localize
            //title: NSLocalizedString("main.delete.alert.title", comment: "Заголовок алерта с подтверждением удаления"),
            title: "По имени",
            style: .destructive
        ) {_ in
           // сортировка по имени
        }
        
        let ratingSort = UIAlertAction(
            //TODO: add localize
            title: "По рейтингу",
            style: .destructive
        ) {_ in
           // сортировка по рейтингу
        }
        
        let cancel = UIAlertAction(
            //TODO: add localize
            title: "Закрыть",
            style: .cancel
        )
        
        let alert = UIAlertController(
            //TODO: добавить локализацию
            title: "Сортировка",
            message: "",
            preferredStyle: .actionSheet)
        
        alert.addAction(nameSort)
        alert.addAction(ratingSort)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}

extension RatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getMockUsers().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RatingViewControllerCell()
        
        let user = getMockUsers()[indexPath.row]
        cell.configure(ratingPosition: user.ratingPosition, name: user.name, avatar: user.avatar, rating: user.rating)
        
        return cell
    }
}

extension RatingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension RatingViewController {
    struct User {
        var ratingPosition: Int
        var name: String
        var avatar: UIImage
        var rating: Int
    }

    func getMockUsers() -> [User] {
        return  [
            User(ratingPosition: 23, name: "Nick", avatar: UIImage(systemName: "person.crop.circle.fill")!, rating: 12),
            User(ratingPosition: 1, name: "Poul", avatar: UIImage(systemName: "person.crop.circle.fill")!, rating: 354),
            User(ratingPosition: 156, name: "PO", avatar: UIImage(systemName: "person.crop.circle.fill")!, rating: 1),
        ]
    }
}
