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
        isUpdating = true
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
                item.name.accept(user.getSnapchatName())
            case .youtube:
                item.name.accept(user.getYoutubeName())
                if user.getYoutubeLink().count > 0  {
                    item.link?.accept(user.getYoutubeLink())
                } else {
                    item.link?.accept(item.linkPrefix)
                }
            case .facebook:
                item.name.accept(user.getFacebookName())
                if user.getFacebookLink().count > 0 {
                    item.link?.accept(user.getFacebookLink())
                } else {
                    item.link?.accept(item.linkPrefix)
                }
            case .twitter:
                item.name.accept(user.getTwitterName())
            case .vimeo:
                item.name.accept(user.getVimeoName())
                if user.getVimeoLink().count > 0 {
                    item.link?.accept(user.getVimeoLink())
                } else {
                    item.link?.accept(item.linkPrefix)
                }
            case .tiktok:
                item.name.accept(user.getTikTokName())
            case .additionalLink:
                item.name.accept(user.getAdditionalName())
                if user.getAdditionalLink().count > 0{
                    item.link?.accept(user.getAdditionalLink())
                } else {
                    item.link?.accept(item.linkPrefix)
                }
            }
            
        }
        
        uploadUserHeaderViewModel.initialImageUrl = user.getImageUrl()
        
    }
    
}
