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
    let type: PostReferenceType
    
    init(referenceType: PostReferenceType, model: Model) {
        self.model = model
        self.type = referenceType
    }
    
    func getModel() -> Model {
        return model
    }
    
    func getType() -> ModelReferenceType {
        return type
    }
    
}

//MARK: - Attribute Case
enum PostReferenceType: ModelReferenceType {
    
    case user
    case category
    
    var key: String {
        switch self {
        case .user: return "user"
        case .category: return "category"
        }
    }
}
