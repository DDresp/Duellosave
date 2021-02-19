//
//  CategorySingleAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//MARK: - Attribute

class CategoryAttribute: ModelAttribute {
    
    var attributeCase: CategoryAttributeCase
    var value: DatabaseConvertibleType?
    
    init(attributeCase: CategoryAttributeCase, value: DatabaseConvertibleType?) {
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
enum CategoryAttributeCase: ModelAttributeCase {
    
    case imageUrl
    case title
    case description
    case creationDate
    case mediaType
    case reportStatus
    case numberOfPosts
    case uid
    case isActive
    
    var entryType: EntryType {
        switch self {
        case .title, .description, .imageUrl, .uid:
            return .String
        case .creationDate:
            return .Double
        case .numberOfPosts:
            return .Int
        case .mediaType:
            return .RoughMediaType
        case .reportStatus:
            return .CategoryReportStatusType
        case .isActive:
            return .Bool
        }
    }
    
    var key: String {
        
        switch self {
        
        case .uid: return "uid"
        case .imageUrl: return "imageUrl"
        case .title: return "title"
        case .description: return "description"
        case .creationDate: return "creationDate"
        case .mediaType: return "type"
        case .reportStatus: return "reportStatus"
        case .numberOfPosts: return "numberOfPosts"
        case .isActive: return "isActive"
            
        }
    }
    
}
