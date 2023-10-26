//
//  NFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 21.10.2023.
//

import Foundation
import UIKit

protocol NFTCollectionPresenterDelegateProtocol: AnyObject {
    func showAlert(alert: AlertModel)
    func reloadData()
    func reloadCell(by indexPath: IndexPath)
    
    func showProgresHUD()
    func dismissProgressHUD()
}

protocol NFTCollectionPresenterProtocol {
    var nftViewModels: [NFTViewModel] { get }
    
    func loadData(nftIDs: [String])
    func didTapLikeNFTButton(isLike: Bool, indexPath: IndexPath)
    func didTapBasketButton(isOnOrder: Bool, indexPath: IndexPath)
}

final class NFTCollectionPresenter: NFTCollectionPresenterProtocol {
    var nftViewModels: [NFTViewModel] = []
    var profile: Profile?
    var likes: Set<String> = []
    var order: ShoppingOrder?
    var inOrder: Set<String> = []
    
    var nftService: NFTServiceProtocol
    var profileService: ProfileServiceProtocol
    var orderService: OrderServiceProtocol
    weak var delegate: NFTCollectionPresenterDelegateProtocol?
    
    init(
        nftService: NFTServiceProtocol,
        profileService: ProfileServiceProtocol,
        orderService: OrderServiceProtocol
    ) {
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
    }
    
    func loadData(nftIDs: [String]) {
        var nfts: [NFT] = []
        
        if nftIDs.count == 0 {
            return
        }
        
        delegate?.showProgresHUD()
        
        let group = DispatchGroup()
        
        group.enter()
        profileService.getProfile(profileID: "1") { [weak self] (result: Result<Profile, Error>) in
            switch result {
            case .failure(let error):
                print("failed to get profile \(error)")
                return
            case .success(let profile):
                guard let self = self else {
                    assertionFailure("getProfile: self is empty")
                    return
                }
                
                self.profile = profile
                self.likes = Set(profile.likes)
            }
            
            group.leave()
        }

        group.enter()
        orderService.getOrder(orderID: "1") { [weak self] (result: Result<ShoppingOrder, Error>) in
            switch result {
            case .failure(let error):
                print("failed to load order witj error \(error)")
                return
            case .success(let order):
                guard let self = self else {
                    assertionFailure("getOrder: self is empty")
                    return
                }
                
                self.order = order
                self.inOrder = Set(order.nfts)
            }
            
            group.leave()
        }
        
        for nftID in nftIDs {
            group.enter()
            nftService.getNFT(id: nftID) { (result: Result<NFT, Error>) in
                switch result {
                case .failure(let error):
                    print("failed to load nft \(nftID) with error: \(error)")
                case .success(let nft):
                    nfts.append(nft)
                }
                
                group.leave()
                
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else {
                assertionFailure("listNFTs: self is empty")
                return
            }
            
            self.delegate?.dismissProgressHUD()
            self.nftViewModels = nfts.map{ self.nftToViewModel(from: $0) }
            self.delegate?.reloadData()
        }
    }
    
    func didTapLikeNFTButton(isLike: Bool, indexPath: IndexPath) {
        guard var updateProfile = profile else {
            assertionFailure("likeNFT: profile is empty")
            return
        }
        
        if isLike {
            updateProfile.likes.append(nftViewModels[indexPath.row].nft.id)
        } else {
            updateProfile.likes.removeAll(where: { $0 == nftViewModels[indexPath.row].nft.id })
        }
        
        profileService.updateProfile(profile: updateProfile) { [weak self] (result: Result<Profile, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    let alertModel = AlertModel(
                        style: .alert,
                        title: NSLocalizedString("alert.update.failed", tableName: "CollectionScreen", comment: ""),
                        actions: [
                            UIAlertAction(
                                title: NSLocalizedString("alert.update.failed.close", tableName: "CollectionScreen", comment: ""),
                                style: .cancel
                            ) { _ in }
                        ]
                    )
                    
                    guard let self = self else {
                        assertionFailure("show alert: self is empty")
                        return
                    }
                    
                    self.delegate?.showAlert(alert: alertModel)
                    print("failed to update profile with error \(error)")
                    return
                case .success(let newProfile):
                    guard let self = self else {
                        assertionFailure("update profile, handle result: self is empty")
                        return
                    }
                    
                    self.profile = newProfile
                    self.nftViewModels[indexPath.row].isLike = isLike
                    self.likes = Set(newProfile.likes)
                    self.delegate?.reloadCell(by: indexPath)
                }
            }
        }
    }
    
    func didTapBasketButton(isOnOrder: Bool, indexPath: IndexPath) {
        guard let order = order else {
            assertionFailure("addToOrder: order is empty")
            return
        }
        
        var newNFTs = order.nfts
        
        if isOnOrder {
            newNFTs.append(nftViewModels[indexPath.row].nft.id)
        } else {
            newNFTs.removeAll(where: { $0 == nftViewModels[indexPath.row].nft.id })
        }
        
        let updateOrder = ShoppingOrder(nfts: newNFTs, id: order.id)
        
        orderService.updateOrder(updateOrder: updateOrder) { [weak self] (result: Result<ShoppingOrder, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    let alertModel = AlertModel(
                        style: .alert,
                        title: NSLocalizedString("alert.update.order.failed", tableName: "CollectionScreen", comment: ""),
                        actions: [
                            UIAlertAction(
                                title: NSLocalizedString("alert.update.order.failed.close", tableName: "CollectionScreen", comment: ""),
                                style: .cancel
                            ) { _ in }
                        ]
                    )
  
                    print("failed to update profile with error \(error)")
                    return
                case .success(let newOrder):
                    guard let self = self else {
                        assertionFailure("updateOrder, handle result: self is empty")
                        return
                    }

                    self.order = newOrder
                    self.inOrder = Set(newOrder.nfts)
                    self.nftViewModels[indexPath.row].isOnOrder = isOnOrder
                    self.delegate?.reloadCell(by: indexPath)
                }
            }
        }
    }
    
    private func nftToViewModel(from nft: NFT) -> NFTViewModel {
        let nftVM = NFTViewModel(
            nft: nft,
            isLike: likes.contains(nft.id),
            isOnOrder: inOrder.contains(nft.id)
        )
        
        return nftVM
    }
}
