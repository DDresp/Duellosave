//
//  UpdateUserViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

class UpdateUserViewModel: UploadUserViewModel {
    
    
    //MARK: - Setup
    init(user: UserModel) {
        super.init()
        cancelTapped = nil //because embedded in NavigationController
        configureViewModels(with: user)
    }
    
    //MARK: - Methods
    func configureViewModels(with user: UserModel) {
        for item in itemViewModels {
            
            switch item.itemType {
            case .username:
                item.name.accept(user.getUserName())
            case .instagram:
                item.name.accept(user.getInstagramName())
            case .snapchat:
                item.name.accept(user.snapchatName.value?.toStringValue())
            case .youtube:
                item.name.accept(user.youtubeName.value?.toStringValue())
                if let name = user.youtubeLink.value?.toStringValue(), name.count > 0  {
                    item.link?.accept(user.youtubeLink.value?.toStringValue())
                } else {
                    item.link?.accept(item.linkPrefix)
                }
            case .facebook:
                item.name.accept(user.facebookName.value?.toStringValue())
                if let name = user.facebookLink.value?.toStringValue(), name.count > 0 {
                    item.link?.accept(user.facebookLink.value?.toStringValue())
                } else {
                    item.link?.accept(item.linkPrefix)
                }
            case .twitter:
                item.name.accept(user.twitterName.value?.toStringValue())
            case .vimeo:
                item.name.accept(user.vimeoName.value?.toStringValue())
                if let name = user.vimeoLink.value?.toStringValue(), name.count > 0 {
                    item.link?.accept(user.vimeoLink.value?.toStringValue())
                } else {
                    item.link?.accept(item.linkPrefix)
                }
            case .tiktok:
                item.name.accept(user.tikTokName.value?.toStringValue())
            case .additionalLink:
                item.name.accept(user.additionalName.value?.toStringValue())
                if let name = user.additionalLink.value?.toStringValue(), name.count > 0{
                    item.link?.accept(user.additionalLink.value?.toStringValue())
                } else {
                    item.link?.accept(item.linkPrefix)
                }
            }
            
        }
        
        if let userImageUrl = user.imageUrl.value?.toStringValue() {
            uploadUserHeaderViewModel.initialImageUrl = userImageUrl
        }
    }
    
}
