//
//  CategorySingleAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//MARK: - Attribute

class CategoryAttribute: ModelAttributeType {
    
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
    
    case title
    case description
    case creationDate
    case type
    
    var entryType: EntryType {
        switch self {
        case .title, .description:
            return .String
        case .creationDate:
            return .Double
        case .type:
            return .RoughMediaType
        }
    }
    
    var key: String {
        
        switch self {
            
        case .title: return "title"
        case .description: return "description"
        case .creationDate: return "creationDate"
        case .type: return "type"
            
        }
    }
    
}



//class CategoryAttribute: ModelAttribute {
//
//    var attributeCase: CategoryAttributeCase
//    var value: DatabaseConvertibleType?
//
//    init(attributeCase: CategoryAttributeCase, value: DatabaseConvertibleType?) {
//        self.attributeCase = attributeCase
//        self.value = value
//    }
//
//    func getCase() -> ModelAttributeCase {
//        return attributeCase
//    }
//
//    func getValue() -> DatabaseConvertibleType? {
//        return value
//    }
//
//    func setValue(of value: DatabaseConvertibleType) {
//        self.value = value
//    }
//
//}
//
////MARK: - Attribute Case
//enum CategoryAttributeCase: ModelAttributeCase {
//
//    case title
//    case description
//    case creationDate
//    case type
//
//    var entryType: EntryType {
//        switch self {
//        case .title, .description:
//            return .String
//        case .creationDate:
//            return .Double
//        case .type:
//            return .RoughMediaType
//        }
//    }
//
//    var key: String {
//
//        switch self {
//
//        case .title: return "title"
//        case .description: return "description"
//        case .creationDate: return "creationDate"
//        case .type: return "type"
//
//        }
//    }
//
//}
//
