//
//  SocialMediaItemViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

class SocialMediaItemViewModel: SocialMediaItemDisplayer {
    
    //MARK: - Variables
    var socialMediaName: String
    var hasLink: Bool
    var type: UserAttributeType
    var iconName: String = ""
    var link: UserAttribute?
    var isDarkMode: Bool
    
    //MARK: - Setup
    init(user: UserModel, socialMediaNameAttribute: UserAttribute, isDarkMode: Bool) {
        self.socialMediaName = user.getSocialMediaName(for: socialMediaNameAttribute) ?? ""
        self.isDarkMode = isDarkMode
        self.link = user.getConnectedLink(for: socialMediaNameAttribute)
        self.hasLink = user.hasLink(for: socialMediaNameAttribute)
        self.type = user.getUserAttributeType(for: socialMediaNameAttribute)
        self.iconName = getIconName(from: type) 
    }
    
    //MARK: - Getters
    private func getIconName(from type: UserAttributeType) -> String {
       
        switch type {
        case .facebookName: return "facebook_hex_icon"
        case .additionalName: return "flckr_hex_icon"
        case .instagramName: return "instagram_hex_icon"
        case .snapchatName: return "pintrest_hex_icon"
        case .twitterName: return "twitter_hex_icon"
        case .vimeoName: return "vimeo_hex_icon"
        case .youtubeName: return "tube_hex_icon"
        case .tikTokName: return "tumblr_hex_icon"
        default: return ""
        }
    }
    
}
