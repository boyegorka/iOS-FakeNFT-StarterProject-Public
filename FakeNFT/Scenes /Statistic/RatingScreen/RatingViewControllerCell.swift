//
//  RatingViewControllerCell.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 09.10.2023.
//

import Foundation
import UIKit

final class RatingViewControllerCell: UITableViewCell {
    var ratingPositionLabel: UILabel = {
        let title = UILabel()
        //TODO: Добавить шрифт SF Pro Text
        // https://developer.apple.com/fonts/
        title.font = .systemFont(ofSize: 15, weight: .regular)
        title.textColor = .textPrimary
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        
        return title
    }()
    
    var userCard: UIView = {
        let view = UIView()
        //TODO: 
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    var avatar: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill")!)
        imageView.tintColor = .gray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
//        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
//
//        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
//
       
        return imageView
    }()

    var nameLabel: UILabel = {
        let title = UILabel()
        //TODO: Добавить шрифт SF Pro Text
        // https://developer.apple.com/fonts/
        title.font = .systemFont(ofSize: 22, weight: .bold)
        title.textColor = .textPrimary
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        
        return title
    }()

    var ratingLabel: UILabel = {
        let title = UILabel()
        //TODO: Добавить шрифт SF Pro Text
        // https://developer.apple.com/fonts/
        title.font = .systemFont(ofSize: 22, weight: .bold)
        title.textColor = .textPrimary
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        
        return title
    }()

    func configure(ratingPosition: String, name: String, avatar: UIImage, rating: String) {
        contentView.addSubview(ratingPosition)
        contentView.addSubview(userCard)
        userCard.addSubview(avatar)
        userCard.addSubview(nameLabel)
        userCard.addSubview(ratingLabel)
        
        
    }
}
