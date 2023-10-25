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
    func showErrorAlert(_ message: String)
    func updateData()
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
    var webViewController: WebViewControllerInput?
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapProfileLink))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
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
        presenter?.viewDidLoad()
        //updateData()
        setupScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        //navigationBar.backgroundColor = view.backgroundColor
        //        navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        navigationBar.shadowImage = UIImage()
        //        navigationBar.isTranslucent = true
        
//        UINavigationBar.appearance().isTranslucent = true
//        UINavigationBar.appearance().tintColor = .red
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .blue
////        appearance.shadowImage = Constants.Appearance.NavigationBar.shadowColor.as1ptImage()
//        appearance.titleTextAttributes[.foregroundColor] = UIColor.green
//        appearance.largeTitleTextAttributes[.foregroundColor] = UIColor.orange
//        appearance.titleTextAttributes[.font] = UIFont.headline2
//        appearance.setBackIndicatorImage(
//            UIImage.strokedCheckmark,
//            transitionMaskImage: UIImage.strokedCheckmark
//        )
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().compactAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        
    }
    
    // MARK: - Public methods
    func showErrorAlert(_ message: String) {
        let actionOK = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.presenter?.viewDidLoad()
        }
        let actionCancel = UIAlertAction(title: "Отменить", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let viewModel = AlertModel(style: .alert, title: "Что-то пошло не так", message: message, actions: [actionOK, actionCancel])
        let presenter = AlertPresenter(delegate: self)
        presenter.show(result: viewModel)
    }
    
    // MARK: - Private methods
    private func setupScreen() {
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        addSubviews()
        
        setData()
    }
    
    private func addSubviews() {
        
        let authorStack = createStackView(axis: .horizontal, alignment: .bottom, distribution: .fill, spacing: 4, margins: .zero, applyMargins: false)
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
        navigationBar.backIndicatorImage = UIImage(named: "backButton")
        navigationBar.topItem?.backButtonTitle = ""
        navigationBar.tintColor = .ypBlack
    }
    
    func updateData() {
        self.collectionAuthorLink.text = self.presenter?.authorProfile?.name
        nftsCollectionView.reloadData()
    }
    
    private func setData() {
        DispatchQueue.main.async {
            self.collectionName.text = self.presenter?.collection.name
            self.coverImage.kf.setImage(with: self.presenter?.collection.cover)
            self.collectionAuthor.text = "Автор коллекции:"
            self.collectionDescription.text = self.presenter?.collection.description
        }
    }
    
    @objc
    private func didTapProfileLink(_ sender: UITapGestureRecognizer) {
        guard let url = presenter?.authorProfile?.website else { return }
        let webView = WebViewController(with: url, output: self)
        webViewController = webView
        self.show(webView, sender: self)
        //navigationController?.pushViewController(webView, animated: true)
        //self.view.addSubview(webView)
        //self.present(webView, animated: true, completion: nil)
        
    }
    
    private func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat, margins: UIEdgeInsets?, applyMargins: Bool) -> UIStackView {
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
    
    private func addArrangedSubviews(stackView: UIStackView, views: [UIView]) {
        for view in views {
            stackView.addArrangedSubview(view)
        }
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.nfts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        if let nft = presenter?.nfts[indexPath.row] {
            cell.viewModel = nft
            cell.isLikedNFT = presenter?.isLikedNFT(nft.id) ?? false
            cell.isAddedToCart = presenter?.isInCart(nft.id) ?? false
        }
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

extension CollectionViewController: WebViewControllerOutput {
    func webViewDidLoad() {
        webViewController?.startLoading()
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
