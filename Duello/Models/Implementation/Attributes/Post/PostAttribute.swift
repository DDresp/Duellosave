//
//  PostSingleAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//MARK: - Attribute

class PostAttribute: ModelAttribute {
    
    private var type: PostAttributeType
    private var value: DatabaseConvertibleType?
    
    init(attributeType: PostAttributeType, value: DatabaseConvertibleType?) {
        self.type = attributeType
        self.value = value
    }
    
    func getType() -> ModelAttributeType {
        return type
    }
    
    func getValue() -> DatabaseConvertibleType? {
        return value
    }
    
    func setValue(of value: DatabaseConvertibleType?) {
        guard let value = value else { return }
        self.value = value
    }
    
}

//MARK: - Attribute Case
enum PostAttributeType: ModelAttributeType {
    
    case uid
    case cid
    case title
    case description
    case rate
    case likes
    case dislikes
    case creationDate
    case imageUrl
    case imageUrls
    case videoUrl
    case thumbNailUrl
    case type
    case apiUrl
    case mediaRatio
    case isDeactivated
    case isBlocked
    case isVerified
    case reportStatus
    
    var entryType: EntryType {
        switch self {
        case .uid, .cid, .title, .description, .imageUrl, .videoUrl, .thumbNailUrl, .apiUrl:
            return .String
        case .dislikes, .likes:
            return .Int
        case .rate, .mediaRatio:
            return .Double
        case .creationDate:
            return .Timestamp
        case .type:
            return .FineMediaType
        case .isDeactivated, .isVerified, .isBlocked:
            return .Bool
        case .reportStatus:
            return .PostReportStatusType
        case .imageUrls:
            return .StringArray
        }
    }
    
    var key: String {
        
        switch self {
            
        case .uid: return "uid"
        case .cid: return "cid"
        case .title: return "title"
        case .description: return "description"
        case .creationDate: return "creationDate"
        case .dislikes: return "dislikes"
        case .likes: return "likes"
        case .rate: return "rate"
        case .imageUrl: return "imageUrl"
        case .imageUrls: return "imageUrls"
        case .type: return "type"
        case .videoUrl: return "videoUrl"
        case .thumbNailUrl: return "thumbNailUrl"
        case .apiUrl: return "apiLink"
        case .mediaRatio: return "mediaRatio"
        case .isVerified: return "isVerified"
        case .isBlocked: return "isBlocked"
        case .isDeactivated: return "isDeactivated"
        case .reportStatus: return "reportStatus"
            
        }
    }
    
}
