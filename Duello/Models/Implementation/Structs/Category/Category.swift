//
//  Category.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

struct Category: CategoryModel {
    
    //MARK: - Variables
    var id: String?
    
    //MARK: - Attributes
    var title: CategoryAttribute = CategoryAttribute(attributeCase: .title, value: nil)
    var description: CategoryAttribute = CategoryAttribute(attributeCase: .description, value: nil)
    var creationDate: CategoryAttribute = CategoryAttribute(attributeCase: .creationDate, value: nil)
    var roughMediaType: CategoryAttribute = CategoryAttribute(attributeCase: .type, value: nil)
    
    
    //MARK: - Getters
    func getAttributes() -> [ModelAttribute] {
        return [
            title,
            description,
            creationDate,
            roughMediaType,
        ]
    }
    
}
