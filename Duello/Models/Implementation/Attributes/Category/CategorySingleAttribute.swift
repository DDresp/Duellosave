//
//  CategorySingleAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//MARK: - Attribute

class CategorySingleAttribute: SingleAttribute {
    
    var attributeCase: CategorySingleAttributeCase
    var value: StringConvertibleType?
    
    init(attributeCase: CategorySingleAttributeCase, value: StringConvertibleType?) {
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
enum CategorySingleAttributeCase: SingleAttributeCase {
    
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

