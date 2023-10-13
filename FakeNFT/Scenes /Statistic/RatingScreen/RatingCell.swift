//
//  RatingViewControllerCell.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 09.10.2023.
//

import Foundation
import UIKit
import Kingfisher

let unknownAvatar = UIImage(systemName: "person.crop.circle.fill")

final class RatingCell: UITableViewCell {
    var ratingPositionLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 15, weight: .regular)
        title.textColor = .textPrimary
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        
        return title
    }()
    
    var userCard: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundLightGray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    var avatarView: UIImageView = {
        let imageView = UIImageView(image: unknownAvatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
 
        return imageView
    }()

    var nameLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 22, weight: .bold)
        title.textColor = .textPrimary
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        
        return title
    }()

    var ratingLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 22, weight: .bold)
        title.textColor = .textPrimary
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        
        return title
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.kf.cancelDownloadTask()
    }
    
    func configure(indexPath: IndexPath, name: String, avatarUrl: String, rating: String) {
        ratingPositionLabel.text = (indexPath.row + 1).description
        nameLabel.text = name
        ratingLabel.text = rating
        
        contentView.addSubview(ratingPositionLabel)
        contentView.addSubview(userCard)
        userCard.addSubview(avatarView)
        userCard.addSubview(nameLabel)
        userCard.addSubview(ratingLabel)
        
        setConstraint()
        
        guard let url = URL(string: avatarUrl) else {
            print("failed to create URL from \(avatarUrl)")
            return
        }
                
        avatarView.kf.setImage(with: url, placeholder: unknownAvatar)
    }
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            ratingPositionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingPositionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingPositionLabel.widthAnchor.constraint(equalToConstant: 27),
            
            userCard.leadingAnchor.constraint(equalTo: ratingPositionLabel.trailingAnchor, constant: 8),
            userCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userCard.heightAnchor.constraint(equalToConstant: 80),
            userCard.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            avatarView.heightAnchor.constraint(equalToConstant: 28),
            avatarView.widthAnchor.constraint(equalToConstant: 28),
            avatarView.leadingAnchor.constraint(equalTo: userCard.leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: userCard.centerYAnchor),
            
            ratingLabel.trailingAnchor.constraint(equalTo: userCard.trailingAnchor, constant: -16),
            ratingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingLabel.leadingAnchor, constant: -8),
            nameLabel.centerYAnchor.constraint(equalTo: userCard.centerYAnchor),
        ])
    }
}
