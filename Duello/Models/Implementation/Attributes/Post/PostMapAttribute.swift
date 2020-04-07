//
//  PostMapAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//MARK: - Attribute
class PostMapAttribute: MapAttribute {
    
    var model: Model
    let attributeCase: PostMapAttributeCase
    
    init(attributeCase: PostMapAttributeCase, model: Model) {
        self.model = model
        self.attributeCase = attributeCase
    }
    
    func getModel() -> Model {
        return model
    }
    
    func getCase() -> MapAttributeCase {
        return attributeCase
    }
    
}

//MARK: - Attribute Case
enum PostMapAttributeCase: MapAttributeCase {
    
    case images
    case user
    case category
    
    var key: String {
        switch self {
        case .images: return "images"
        case .user: return "user"
        case .category: return "category"
        }
    }
}
