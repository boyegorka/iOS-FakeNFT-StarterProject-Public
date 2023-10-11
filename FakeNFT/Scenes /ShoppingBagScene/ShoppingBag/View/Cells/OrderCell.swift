//
//  OrderCell.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import UIKit
import Kingfisher

final class OrderCell: UITableViewCell, ReuseIdentifying {
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Цена"

        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let trashButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "trashIcon"), for: .normal)
        button.tintColor = .textPrimary

        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        trashButton.addTarget(self, action: #selector(didTapTrashButton), for: .touchUpInside)

        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)

        contentView.addSubview(previewImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingImageView)
        contentView.addSubview(priceTitleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(trashButton)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.kf.cancelDownloadTask()
    }

    func configure(from cellModel: OrderCellModel) {
        previewImageView.kf.setImage(with: cellModel.imageURL)
        titleLabel.text = cellModel.title
        ratingImageView.image = UIImage(named: "stars\(cellModel.rating)")
        priceLabel.text = "\(cellModel.price) ETH"
    }
}

private extension OrderCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            previewImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            previewImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            previewImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            previewImageView.heightAnchor.constraint(equalToConstant: 108),
            previewImageView.widthAnchor.constraint(equalToConstant: 108),

            titleLabel.topAnchor.constraint(equalTo: previewImageView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: 20),


            ratingImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            priceTitleLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            priceTitleLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 12),

            priceLabel.leadingAnchor.constraint(equalTo: priceTitleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),

            trashButton.centerYAnchor.constraint(equalTo: previewImageView.centerYAnchor),
            trashButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    @objc func didTapTrashButton() {
        print(#function)
    }
}
