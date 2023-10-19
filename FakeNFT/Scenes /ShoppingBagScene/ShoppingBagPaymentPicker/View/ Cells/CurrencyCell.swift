//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 16.10.2023.
//

import UIKit
import Kingfisher

final class CurrencyCell: UICollectionViewCell, ReuseIdentifying {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let iconImageViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBlackUniversal
        view.layer.cornerRadius = 6
        view.clipsToBounds = true

        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption2

        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption2
        label.textColor = .ypGreenUniversal

        return label
    }()

    private var cellModel: CurrencyCellModel?

    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.layer.borderColor = UIColor.ypBlackUniversal.cgColor
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .ypLightGray

        iconImageViewContainer.addSubview(iconImageView)
        contentView.addSubview(iconImageViewContainer)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        iconImageView.kf.cancelDownloadTask()
    }

    func configure(from cellModel: CurrencyCellModel) {
        guard let imageURL = URL(string: cellModel.currency.image) else {
            return
        }

        self.cellModel = cellModel
        iconImageView.kf.setImage(with: imageURL)
        titleLabel.text = cellModel.currency.title
        nameLabel.text = cellModel.currency.name
    }

    func setActiveState(_ isSelected: Bool) {
        cellModel?.isActive = isSelected
        contentView.layer.borderWidth = isSelected ? 1 : 0
    }
}

private extension CurrencyCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconImageViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            iconImageViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            iconImageViewContainer.widthAnchor.constraint(equalToConstant: 36),

            iconImageView.centerXAnchor.constraint(equalTo: iconImageViewContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconImageViewContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalToConstant: 36),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),

            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
}
