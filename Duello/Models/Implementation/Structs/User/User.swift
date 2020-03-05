//
//  User.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

struct User: UserModel {
    
    //MARK: - Variables
    var id: String?
    var score: Double?
    
    //MARK: - Attributes
    var userName = UserSingleAttribute(attributeCase: .userName, value: "Default User Name")
    
    var instagramName = UserSingleAttribute(attributeCase: .instagramName, value: nil)
    var snapchatName = UserSingleAttribute(attributeCase: .snapchatName, value: nil)
    var youtubeName = UserSingleAttribute(attributeCase: .youtubeName, value: nil)
    var facebookName = UserSingleAttribute(attributeCase: .facebookName, value: nil)
    var twitterName = UserSingleAttribute(attributeCase: .twitterName, value: nil)
    var vimeoName = UserSingleAttribute(attributeCase: .vimeoName, value: nil)
    var tikTokName = UserSingleAttribute(attributeCase: .tikTokName, value: nil)
    var additionalName = UserSingleAttribute(attributeCase: .additionalName, value: nil)
    
    var youtubeLink = UserSingleAttribute(attributeCase: .youtubeLink, value: nil)
    var facebookLink = UserSingleAttribute(attributeCase: .facebookLink, value: nil)
    var vimeoLink = UserSingleAttribute(attributeCase: .vimeoLink, value: nil)
    var additionalLink = UserSingleAttribute(attributeCase: .additionalLink, value: nil)
    var instagramLink = UserSingleAttribute(attributeCase: .instagramLink, value: nil)
    var twitterLink = UserSingleAttribute(attributeCase: .twitterLink, value: nil)
    var snapChatLink = UserSingleAttribute(attributeCase: .snapchatLink, value: nil)
    
    var imageUrl = UserSingleAttribute(attributeCase: .imageUrl, value: nil)
    
    //MARK: - Getters
    var allAttributes: [UserSingleAttribute] {
        
        return [
            userName,
            instagramName,
            snapchatName,
            youtubeName,
            facebookName,
            twitterName,
            vimeoName,
            tikTokName,
            additionalName,
            youtubeLink,
            facebookLink,
            vimeoLink,
            additionalLink,
            instagramLink,
            snapChatLink,
            twitterLink,
            imageUrl
        ]
        
    }
    
    var addedSocialMediaName: Bool {
        let allSocialMediaNames = getAllSocialMediaNames()
        for socialMediaName in allSocialMediaNames {
            if socialMediaName.value != nil { return true}
        }
        return false
    }
    
    func hasConnectedLink(for attribute: UserSingleAttribute) -> Bool {
        if !attribute.attributeCase.isSocialMediaName { return false }
        return getConnectedLink(for: attribute) == nil ? false : true
    }
    
    func getAllSocialMediaNames() -> [UserSingleAttribute] {
        
        var socialMediaNames = [UserSingleAttribute]()
        for attribute in allAttributes {
            if attribute.attributeCase.isSocialMediaName {
                socialMediaNames.append(attribute)
            }
        }
        return socialMediaNames
        
    }
    
    func getConnectedLink(for attribute: UserSingleAttribute) -> UserSingleAttribute? {
        guard let connectedLinkType = attribute.attributeCase.connectedLinkAttributeCase else { return nil }
        
        for attribute in allAttributes {
            if attribute.attributeCase == connectedLinkType { return attribute }
        }
        
        return nil
    }
    
    func getSingleAttributes() -> [SingleAttribute] {
        return allAttributes
    }
    
}
