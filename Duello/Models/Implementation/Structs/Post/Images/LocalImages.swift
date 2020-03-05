//
//  LocalImages.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

struct LocalImages: Model {
    
    //MARK: - Variables
    var id: String?
    var name = "images"
    
    //MARK: - Attributes
    var imageUrl1 = PostSingleAttribute(attributeCase: .imageUrl(0), value: nil)
    var imageUrl2 = PostSingleAttribute(attributeCase: .imageUrl(1), value: nil)
    var imageUrl3 = PostSingleAttribute(attributeCase: .imageUrl(2), value: nil)
    var imageUrl4 = PostSingleAttribute(attributeCase: .imageUrl(3), value: nil)
    var imageUrl5 = PostSingleAttribute(attributeCase: .imageUrl(4), value: nil)
    var imageUrl6 = PostSingleAttribute(attributeCase: .imageUrl(5), value: nil)
    
    //MARK: - Getters
    func getSingleAttributes() -> [SingleAttribute] {
        return [
            imageUrl1,
            imageUrl2,
            imageUrl3,
            imageUrl4,
            imageUrl5,
            imageUrl6
        ]
    }
    
}
