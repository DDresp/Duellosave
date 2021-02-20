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
    var userName = UserAttribute(attributeCase: .userName, value: "Default User Name")
    
    var instagramName = UserAttribute(attributeCase: .instagramName, value: nil)
    var snapchatName = UserAttribute(attributeCase: .snapchatName, value: nil)
    var youtubeName = UserAttribute(attributeCase: .youtubeName, value: nil)
    var facebookName = UserAttribute(attributeCase: .facebookName, value: nil)
    var twitterName = UserAttribute(attributeCase: .twitterName, value: nil)
    var vimeoName = UserAttribute(attributeCase: .vimeoName, value: nil)
    var tikTokName = UserAttribute(attributeCase: .tikTokName, value: nil)
    var additionalName = UserAttribute(attributeCase: .additionalName, value: nil)
    
    var youtubeLink = UserAttribute(attributeCase: .youtubeLink, value: nil)
    var facebookLink = UserAttribute(attributeCase: .facebookLink, value: nil)
    var vimeoLink = UserAttribute(attributeCase: .vimeoLink, value: nil)
    var additionalLink = UserAttribute(attributeCase: .additionalLink, value: nil)
    var instagramLink = UserAttribute(attributeCase: .instagramLink, value: nil)
    var twitterLink = UserAttribute(attributeCase: .twitterLink, value: nil)
    var snapchatLink = UserAttribute(attributeCase: .snapchatLink, value: nil)
    
    var imageUrl = UserAttribute(attributeCase: .imageUrl, value: nil)
    
    //MARK: - Getters
    var addedSocialMediaName: Bool {
        let allSocialMediaNames = getAllSocialMediaNameAttributes()
        for socialMediaName in allSocialMediaNames {
            if socialMediaName.value != nil { return true}
        }
        return false
    }
    
    func hasConnectedLink(for attribute: UserAttribute) -> Bool {
        if !attribute.type.isSocialMediaName { return false }
        return getConnectedLink(for: attribute) == nil ? false : true
    }
    
    func getAllSocialMediaNameAttributes() -> [UserAttribute] {
        var socialMediaNames = [UserAttribute]()
        guard let attributes = properties.attributes as? [UserAttribute] else { return socialMediaNames }
        
        for attribute in attributes {
            if attribute.type.isSocialMediaName {
                socialMediaNames.append(attribute)
            }
        }
        
        return socialMediaNames
    }
    
    
    func getConnectedLink(for attribute: UserAttribute) -> UserAttribute? {
        guard let connectedLinkType = attribute.type.connectedLinkAttributeCase else { return nil }
        guard let attributes = properties.attributes as? [UserAttribute] else { return nil }
        
        for attribute in attributes {
            if attribute.type == connectedLinkType { return attribute }
        }
        
        return nil
    }

}
