//
//  ProfileViewPresenter.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 18.10.2023.
//

import Foundation
import UIKit

protocol ProfileViewPresenterProtocol {
    var user: User { get }
    
    func didTapProfileWebsite()
    func didTapNFTsCollection()
    func setImage()
}

protocol ProfileViewPresenterDelegateProtocol: AnyObject {
    var avatarView: UIImageView { get set }
    
    func showAlert(alert: AlertModel)
    func showSubViewController(_ subViewController: UIViewController)
    func closeSubViewController()
    func setImage(url: URL)
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var user: User
    
    weak var delegate: ProfileViewPresenterDelegateProtocol?
    var webViewController: WebViewControllerInput?
    
    init(user: User) {
        self.user = user
    }
    
    func didTapProfileWebsite() {
        guard
            let delegate = delegate,
            let url = URL(string: user.website)
        else {
            let alertModel = AlertModel(
                style: .alert,
                title: NSLocalizedString("alert.bad.url", tableName: "StatisticProfileScreen", comment: ""),
                actions: [
                    UIAlertAction(
                        title: NSLocalizedString("alert.bad.url.close", tableName: "StatisticProfileScreen", comment: ""),
                        style: .cancel
                    ) { _ in }
                ]
            )
            delegate?.showAlert(alert: alertModel)
            
            return
        }
        
        let webViewController = WebViewController(with: url, output: self)
        self.webViewController = webViewController
        
        delegate.showSubViewController(webViewController)
    }

    func didTapNFTsCollection() {
        let defaultNetworkClient = DefaultNetworkClient()
        let collectionPresenter = NFTCollectionPresenter(
            nftService: NFTService(networkClient: defaultNetworkClient),
            profileService: ProfileService(networkClient: defaultNetworkClient),
            orderService: OrderService(networkClient: defaultNetworkClient)
        )
        let collectionVC = NFTsCollectionView(nfts: user.nfts, presenter: collectionPresenter)

        collectionPresenter.delegate = collectionVC
        
        delegate?.showSubViewController(collectionVC)
    }
    
    func setImage() {
        guard
            let delegate = delegate,
            let url = URL(string: user.avatarUrl)
        else {
            print("failed to get url from \(user.avatarUrl)")
            return
        }
        delegate.setImage(url: url)
    }
}

extension ProfileViewPresenter: WebViewControllerOutput {
    func webViewDidLoad() {
        webViewController?.startLoading()
    }
    
    func didTapBackButton() {
        delegate?.closeSubViewController()
    }
}
