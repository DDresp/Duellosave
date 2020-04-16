//
//  PostSingleAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//MARK: - Attribute

class PostAttribute: ModelAttribute {
    
    var attributeCase: PostAttributeCase
    var value: DatabaseConvertibleType?
    
    init(attributeCase: PostAttributeCase, value: DatabaseConvertibleType?) {
        self.attributeCase = attributeCase
        self.value = value
    }
    
    func getCase() -> ModelAttributeCase {
        return attributeCase
    }
    
    func getValue() -> DatabaseConvertibleType? {
        return value
    }
    
    func setValue(of value: DatabaseConvertibleType) {
        self.value = value
    }
    
}

//MARK: - Attribute Case
enum PostAttributeCase: ModelAttributeCase {
    
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
    case report
    
    var entryType: EntryType {
        switch self {
        case .uid, .cid, .title, .description, .imageUrl, .videoUrl, .thumbNailUrl, .apiUrl:
            return .String
        case .dislikes, .likes:
            return .Int
        case .rate, .creationDate, .mediaRatio:
            return .Double
        case .type:
            return .FineMediaType
        case .isDeactivated:
            return .Bool
        case .report:
            return .ReportType
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
        case .isDeactivated: return "isDeactivated"
        case .report: return "report"
            
        }
    }
    
}
