//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 18.10.2023.
//

import UIKit
import Kingfisher

protocol CollectionViewControllerProtocol: AnyObject {
    var presenter: CollectionPresenterProtocol? { get }
}

final class CollectionViewController: UIViewController, CollectionViewControllerProtocol {
    
    // MARK: - Enum
    private enum Contstants {
        static let cellIdentifier = "NFTCell"
        static let contentInsets: CGFloat = 16
        static let spacing: CGFloat = 10
    }
    
    // MARK: - Public Properties
    var presenter: CollectionPresenterProtocol?
    
    // MARK: - Private Properties
    
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .ypWhite
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var coverImage: UIImageView = {
        var image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        image.heightAnchor.constraint(equalToConstant: 310).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var collectionName: UILabel = {
        var label = UILabel()
        label.textColor = .ypBlack
        label.font = .headline3
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionAuthor: UILabel = {
        var label = UILabel()
        label.textColor = .ypBlack
        label.font = .caption2
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionAuthorLink: UILabel = {
        var label = UILabel()
        label.textColor = .ypBlueUniversal
        label.font = .caption1
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionDescription: UILabel = {
        var label = UILabel()
        label.textColor = .ypBlack
        label.font = .caption2
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftsCollectionView: ResizableCollectionView = {
        let collectionView = ResizableCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(NFTCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Contstants.contentInsets, bottom: Contstants.contentInsets, right: Contstants.contentInsets)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    // MARK: - Private methods
    private func setupScreen() {
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        addSubviews()
        
        // это временные данные, поскольку для второго эпика стояла задача сделать вёрстку
        collectionName.text = "Имя коллекции"
        coverImage.kf.setImage(with: "https://image.mel.fm/i/l/lgMrg9iMvS/640.jpg".getUrl())
        collectionAuthor.text = "Автор коллекции"
        collectionAuthorLink.text = "Имя автора"
        collectionDescription.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English."
    }
    
    private func addSubviews() {
        
        let authorStack = createStackView(axis: .horizontal, alignment: .leading, distribution: .fill, spacing: 4, margins: .zero, applyMargins: false)
        addArrangedSubviews(stackView: authorStack, views: [collectionAuthor, collectionAuthorLink])
        
        let nameAndAuthorStack = createStackView(axis: .vertical, alignment: .leading, distribution: .fill, spacing: 15, margins: .zero, applyMargins: false)
        addArrangedSubviews(stackView: nameAndAuthorStack, views: [collectionName, authorStack])
        
        let infoStack = createStackView(axis: .vertical, alignment: .leading, distribution: .fill, spacing: 5, margins: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), applyMargins: true)
        addArrangedSubviews(stackView: infoStack, views: [nameAndAuthorStack, collectionDescription])
        
        let mainStack = createStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 16, margins: .zero, applyMargins: false)
        addArrangedSubviews(stackView: mainStack, views: [coverImage, infoStack, nftsCollectionView])
        
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainStack.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
            mainStack.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        navigationBar.backIndicatorImage = UIImage(named: "backButton")
        navigationBar.topItem?.backButtonTitle = ""
        navigationBar.tintColor = .ypBlack
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat, margins: UIEdgeInsets?, applyMargins: Bool) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.layoutMargins = margins ?? .zero
        stackView.isLayoutMarginsRelativeArrangement = applyMargins
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func addArrangedSubviews(stackView: UIStackView, views: [UIView]) {
        for view in views {
            stackView.addArrangedSubview(view)
        }
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.viewModel = NFTModel(nft: NFT(id: "1", name: "Picachu", images: ["https://avatars.mds.yandex.net/i?id=57f147a252093a28d9793aa75c4cfa78713a0dd4-9220617-images-thumbs&n=13"], rating: 3, price: 1.2))
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - Contstants.contentInsets * 2 - Contstants.spacing * 2) / 3
        return CGSize(width: width,
                      height: width + 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return Contstants.spacing
    }
}
