//
//  RatingViewController.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 09.10.2023.
//

import Foundation
import UIKit

let horizontalPadding: CGFloat = 16
let rowHeight: CGFloat = 80

final class RatingViewController: UIViewController {
    private let cellIdentifier = "cell"
    
    lazy private var sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.backgroundColor = .background
        
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
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
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
}

extension RatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getMockUsers().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .red
        
        return cell
    }
}

extension RatingViewController: UITableViewDelegate {
    
}



extension RatingViewController {
    struct User {
        var name: String
        var avatar: UIImage
        var rating: Int
    }

    func getMockUsers() -> [User] {
        return  [
            User(name: "Nick", avatar: UIImage(systemName: "person.crop.circle.fill")!, rating: 12),
            User(name: "Poul", avatar: UIImage(systemName: "person.crop.circle.fill")!, rating: 354),
            User(name: "PO", avatar: UIImage(systemName: "person.crop.circle.fill")!, rating: 1),
        ]
    }
}
