//
//  NFTCell.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 18.10.2023.
//

import UIKit
import Kingfisher

protocol NFTCellDelegate: AnyObject {
    func didTapLikeButton(_ id: String)
    func didTapCartButton(_ id: String)
}

class NFTCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Public Properties
    weak var delegate: NFTCellDelegate?
    
    var isLikedNFT: Bool = false {
        didSet {
            updateLikedButton()
        }
    }
    
    var isAddedToCart: Bool = false {
        didSet {
            updateCartButton()
        }
    }
    
    var viewModel: NFTModel? {
        didSet {
            guard let viewModel else { return }
            setupViewModel(viewModel: viewModel)
        }
    }
    
    // MARK: - Private Properties
    
    private var stars: [UIImageView] = []
    
    private lazy var nftImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1).isActive = true
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToFavourites), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .bodyBold
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .caption3
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        button.tintColor = .ypBlack
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .ypWhite
        addSubviews()
        updateLikedButton()
        updateCartButton()
    }
    
    private func addSubviews() {
        createStars()
                
        let nameAndPriceStack = createStackView(axis: .vertical, alignment: .leading, distribution: .fillProportionally, spacing: 4)
        addArrangedSubviews(stackView: nameAndPriceStack, views: [nameLabel, priceLabel])
        
        let infoAndCartStack = createStackView(axis: .horizontal, alignment: .top, distribution: .fill, spacing: 0)
        addArrangedSubviews(stackView: infoAndCartStack, views: [nameAndPriceStack, cartButton])
        
        let starsStack = createStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 2)
        var viewStars: [UIView] = stars
        viewStars.append(UIView())
        addArrangedSubviews(stackView: starsStack, views: viewStars)
        
        let starsAndInfoStack = createStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 4)
        addArrangedSubviews(stackView: starsAndInfoStack, views: [starsStack, infoAndCartStack])
        
        let mainStack = createStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 8)
        addArrangedSubviews(stackView: mainStack, views: [nftImage, starsAndInfoStack])
        
        addSubview(mainStack)
        addSubview(likeButton)
        
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: 0),
            likeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 0),
            
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func addArrangedSubviews(stackView: UIStackView, views: [UIView]) {
        for view in views {
            stackView.addArrangedSubview(view)
        }
    }
    
    private func createStars() {
        var starsArray: [UIImageView] = []
        for index in 1...5 {
            let star = createStarIcon()
            star.tag = index
            starsArray.append(star)
        }
        stars = starsArray
    }
    
    private func createStarIcon() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func updateLikedButton() {
        switch isLikedNFT {
        case true:
            likeButton.setImage(UIImage(named: "FavouriteFilled"), for: .normal)
        case false:
            likeButton.setImage(UIImage(named: "Favourite"), for: .normal)
        }
    }
    
    private func updateCartButton() {
        switch isAddedToCart {
        case true:
            cartButton.setImage(UIImage(named: "CartFilled"), for: .normal)
        case false:
            cartButton.setImage(UIImage(named: "Cart"), for: .normal)
        }
    }
    
    private func setupViewModel(viewModel: NFTModel) {
        nftImage.kf.indicatorType = .activity
        nftImage.kf.setImage(with: viewModel.image)
        nameLabel.text = viewModel.name
        priceLabel.text = "\(viewModel.price) ETH"
        setRating(viewModel.rating)
    }
    
    private func setRating(_ rating: Int) {
        guard !stars.isEmpty else { return }
        stars.forEach { $0.image = UIImage(named: "Star") }
        for index in 0...rating-1 {
            stars[index].image = UIImage(named: "StarFilled")
        }
    }
    
    @objc
    private func addToFavourites() {
        guard let viewModel else { return }
        isLikedNFT.toggle()
        delegate?.didTapLikeButton(viewModel.id)
    }
    
    @objc
    private func addToCart() {
        guard let viewModel else { return }
        isAddedToCart.toggle()
        delegate?.didTapCartButton(viewModel.id)
    }
}
