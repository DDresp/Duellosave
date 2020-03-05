//
//  PostSingleAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//MARK: - Attribute
class PostSingleAttribute: SingleAttribute {
    
    var attributeCase: PostSingleAttributeCase
    var value: StringConvertibleType?
    
    init(attributeCase: PostSingleAttributeCase, value: StringConvertibleType?) {
        self.attributeCase = attributeCase
        self.value = value
    }
    
    func getCase() -> SingleAttributeCase {
        return attributeCase
    }
    
    func getValue() -> StringConvertibleType? {
        return value
    }
    
    func setValue(of value: StringConvertibleType) {
        self.value = value
    }
    
}

//MARK: - Attribute Case
enum PostSingleAttributeCase: SingleAttributeCase {
    
    case uid
    case title
    case description
    case rate
    case likes
    case dislikes
    case creationDate
    case imageUrl(Int)
    case videoUrl
    case thumbNailUrl
    case type
    case apiUrl
    
    var entryType: EntryType {
        switch self {
        case .uid, .title, .description, .imageUrl, .videoUrl, .thumbNailUrl, .apiUrl:
            return .String
        case .dislikes, .likes:
            return .Int
        case .rate, .creationDate:
            return .Double
        case .type:
            return .MediaType
        }
    }
    
    var key: String {
        
        switch self {
            
        case .uid: return "uid"
        case .title: return "title"
        case .description: return "description"
        case .creationDate: return "creationDate"
        case .dislikes: return "dislikes"
        case .likes: return "likes"
        case .rate: return "rate"
        case .imageUrl(let index):
            if index == 0 {
                return "imageUrl"
            } else {
                return "imageUrl\(index + 1)"
            }
        case .type: return "type"
        case .videoUrl: return "videoUrl"
        case .thumbNailUrl: return "thumbNailUrl"
        case .apiUrl: return "apiLink"
            
        }
    }
}
