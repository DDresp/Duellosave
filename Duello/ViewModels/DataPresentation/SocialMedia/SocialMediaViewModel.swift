//
//  SocialMediaViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class SocialMediaViewModel: SocialMediaDisplayer {
    
    //MARK: - Models
    var user: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
    
    //MARK: - ChildViewModels
    var items = [SocialMediaItemDisplayer]()
    
    //MARK: - Variables
    var sizes: [Int: CGSize] = [Int: CGSize]()
    var isDarkMode: Bool
    
    //MARK: - Bindables
    var reloadData: BehaviorRelay<Void> = BehaviorRelay<Void>(value: ())
    var selectedItemIndex: PublishRelay<Int?> = PublishRelay<Int?>()
    var selectedLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var cleanCache: PublishRelay<Void> = PublishRelay<Void>()
    
    //MARK: - Setup
    init(isDarkMode: Bool) {
        self.isDarkMode = isDarkMode
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Methods
    private func setAttributes() {
        items = []
        guard let user = user.value else { return }
        let allSocialMediaNames = user.getAllSocialMediaNames()
        
        for socialMediaName in allSocialMediaNames {
            if let name = socialMediaName.value {
                let connectedLink = user.getConnectedLink(for: socialMediaName)
                let itemViewModel = SocialMediaItemViewModel(socialMediaName: nameString.toStringValue(), link: connectedLink, type: socialMediaName.type, isDarkMode: isDarkMode)
                items.append(itemViewModel)
            }
        }
        
//        for socialMediaName in allSocialMediaNames {
//            if let nameString = socialMediaName.value {
//                let connectedLink = user.getConnectedLink(for: socialMediaName)
//                let itemViewModel = SocialMediaItemViewModel(socialMediaName: nameString.toStringValue(), link: connectedLink, type: socialMediaName.type, isDarkMode: isDarkMode)
//                items.append(itemViewModel)
//            }
//        }
        
        reloadData.accept(())
    }
    
    //MARK: - Getters
    var numberOfItemDisplayers: Int {
        return items.count
    }
    
    func getItemDisplayer(for indexPath: IndexPath) -> SocialMediaItemDisplayer {
        return items[indexPath.item]
    }
    
    func itemHasLink(for indexPath: IndexPath) -> Bool {
        let item = items[indexPath.item]
        return item.hasLink
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        user.asObservable().subscribe(onNext: { [weak self] (user) in
            self?.setAttributes()
        }).disposed(by: disposeBag)
        
        selectedItemIndex.asObservable().map { [weak self] (index) -> UserAttribute? in
            guard let index = index else { return nil}
            guard let link = self?.items[index].link else { return nil}
            return link
            }.subscribe(onNext: { [weak self] (link) in
                guard let link = link else { return }
                guard let linkString = link.value?.toStringValue() else { return }
                
                if link.type == .additionalLink {
                    self?.showAdditionalLinkAlert.accept(linkString)
                } else {
                    self?.selectedLink.accept(linkString)
                }
                
            }).disposed(by: disposeBag)
        
        cleanCache.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.sizes.removeAll()
        }).disposed(by: disposeBag)
        
    }
    
}
