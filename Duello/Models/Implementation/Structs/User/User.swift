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
    var creationDate = UserAttribute(attributeType: .creationDate, value: nil)
    
    var userName = UserAttribute(attributeType: .userName, value: "Default User Name")
    
    var instagramName = UserAttribute(attributeType: .instagramName, value: nil)
    var snapchatName = UserAttribute(attributeType: .snapchatName, value: nil)
    var youtubeName = UserAttribute(attributeType: .youtubeName, value: nil)
    var facebookName = UserAttribute(attributeType: .facebookName, value: nil)
    var twitterName = UserAttribute(attributeType: .twitterName, value: nil)
    var vimeoName = UserAttribute(attributeType: .vimeoName, value: nil)
    var tikTokName = UserAttribute(attributeType: .tikTokName, value: nil)
    var additionalName = UserAttribute(attributeType: .additionalName, value: nil)
    
    var youtubeLink = UserAttribute(attributeType: .youtubeLink, value: nil)
    var facebookLink = UserAttribute(attributeType: .facebookLink, value: nil)
    var vimeoLink = UserAttribute(attributeType: .vimeoLink, value: nil)
    var additionalLink = UserAttribute(attributeType: .additionalLink, value: nil)
    var instagramLink = UserAttribute(attributeType: .instagramLink, value: nil)
    var twitterLink = UserAttribute(attributeType: .twitterLink, value: nil)
    var snapchatLink = UserAttribute(attributeType: .snapchatLink, value: nil)
    
    var imageUrl = UserAttribute(attributeType: .imageUrl, value: nil)
    
    //MARK: - Getters
    var addedSocialMediaName: Bool {
        let allSocialMediaNames = getAllSocialMediaNameAttributes()
        for socialMediaName in allSocialMediaNames {
            if getIsAvailable(attribute: socialMediaName) { return true }
        }
        return false
    }
    
    func hasConnectedLink(for attribute: UserAttribute) -> Bool {
        guard getUserAttributeType(for: attribute).isSocialMediaName else { return false }
        return getConnectedLink(for: attribute) == nil ? false : true
    }
    
    func getAllSocialMediaNameAttributes() -> [UserAttribute] {
        var socialMediaNames = [UserAttribute]()
        guard let attributes = properties.attributes as? [UserAttribute] else { return socialMediaNames }
        
        for attribute in attributes {
            if getUserAttributeType(for: attribute).isSocialMediaName {
                socialMediaNames.append(attribute)
            }
        }
        
        return socialMediaNames
    }
    
    
    func getConnectedLink(for attribute: UserAttribute) -> UserAttribute? {
        guard let connectedLinkType = getUserAttributeType(for: attribute).connectedLinkAttributeType else { return nil }
        guard let attributes = properties.attributes as? [UserAttribute] else { return nil }
        
        for attribute in attributes {
            if getUserAttributeType(for: attribute) == connectedLinkType { return attribute }
        }
        
        return nil
    }

}
