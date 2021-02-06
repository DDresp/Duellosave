//
//  PostMapAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//MARK: - Attribute
class PostReference: ModelReference {

    var model: Model
    let attributeCase: PostReferenceCase
    
    init(attributeCase: PostReferenceCase, model: Model) {
        self.model = model
        self.attributeCase = attributeCase
    }
    
    func getModel() -> Model {
        return model
    }
    
    func getCase() -> ModelReferenceCase {
        return attributeCase
    }
    
}

//MARK: - Attribute Case
enum PostReferenceCase: ModelReferenceCase {
    
    case user
    case category
    
    var key: String {
        switch self {
        case .user: return "user"
        case .category: return "category"
        }
    }
}
