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
    var type: UserSingleAttributeCase
    var iconName: String = ""
    var link: UserSingleAttribute?
    var isDarkMode: Bool
    
    //MARK: - Setup
    init(socialMediaName: String, link: UserSingleAttribute?, type: UserSingleAttributeCase, isDarkMode: Bool) {
        self.socialMediaName = socialMediaName
        self.isDarkMode = isDarkMode
        self.hasLink = link?.value != nil
        self.type = type
        self.link = link
        self.iconName = getIconName(from: type)
    }
    
    //MARK: - Getters
    private func getIconName(from type: UserSingleAttributeCase) -> String {
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
