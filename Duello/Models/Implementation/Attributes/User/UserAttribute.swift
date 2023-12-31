//
//  UserSingleAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase

//MARK: - Attribute
class UserAttribute: ModelAttribute {
    
    private var type: UserAttributeType
    private var value: DatabaseConvertibleType?
    
    init(attributeType: UserAttributeType, value: DatabaseConvertibleType?) {
        self.type = attributeType
        self.value = value
    }
    
    func getValue() -> DatabaseConvertibleType? {
        return value
    }
    
    func setValue(of value: DatabaseConvertibleType?) {
        guard let value = value else { return }
        self.value = value
    }
    
    func getType() -> ModelAttributeType {
        return type
    }
}

//MARK: - Attribute Case
enum UserAttributeType: ModelAttributeType {
    
    case creationDate
    
    case userName
    
    case instagramName
    case snapchatName
    case youtubeName
    case facebookName
    case twitterName
    case vimeoName
    case tikTokName
    case additionalName
    
    case instagramLink
    case snapchatLink
    case twitterLink
    case youtubeLink
    case facebookLink
    case vimeoLink
    case additionalLink
    
    case imageUrl
    
    var required: Bool {
        switch self {
        case .userName: return true
        default: return false
        }
    }
    
    var isSocialMediaName: Bool {
        
        switch self {
            
        case .instagramName, .snapchatName, .youtubeName, .facebookName, .twitterName, .vimeoName, .tikTokName, .additionalName  : return true
        default: return false
            
        }
    }
    
    var hasComputedLink: Bool {
        
        switch self {
            
        case .instagramName, .snapchatName, .twitterName : return true
        default: return false
            
        }
    }
    
    var connectedLinkAttributeType: UserAttributeType? {
        
        switch self {
        case .youtubeName: return .youtubeLink
        case .facebookName: return .facebookLink
        case .vimeoName: return .vimeoLink
        case .additionalName: return .additionalLink
        case .instagramName: return .instagramLink
        case .snapchatName: return .snapchatLink
        case .twitterName: return .twitterLink
        default: return nil
        }
    }
    
    var entryType: EntryType {
        
        switch self {
        case .creationDate:
            return .Timestamp
        default:
            return .String
        }
        
    }
    
    var key: String {
        
        switch self {
        
        case .creationDate: return "creationDate"
        case .userName: return "username"
        case .instagramName: return "instagramName"
        case .snapchatName: return "snapchatName"
        case .youtubeName: return "youtubeName"
        case .facebookName: return "facebookName"
        case .twitterName: return "twitterName"
        case .vimeoName: return "vimeoName"
        case .tikTokName: return "tikTokName"
        case .additionalName: return "additionalName"
            
        case .youtubeLink: return "youtubeLink"
        case .facebookLink: return "facebookLink"
        case .vimeoLink: return "vimeoLink"
        case .additionalLink: return "additionalLink"
        case .snapchatLink: return "snapchatLink"
        case .instagramLink: return "instagramLink"
        case .twitterLink: return "twitterLink"
            
        case .imageUrl: return "imageUrl"
            
        }
    }
}
