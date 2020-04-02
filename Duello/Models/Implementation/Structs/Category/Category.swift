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
    var title: CategorySingleAttribute = CategorySingleAttribute(attributeCase: .title, value: nil)
    var description: CategorySingleAttribute = CategorySingleAttribute(attributeCase: .description, value: nil)
    var creationDate: CategorySingleAttribute = CategorySingleAttribute(attributeCase: .creationDate, value: nil)
    var typeData: CategorySingleAttribute = CategorySingleAttribute(attributeCase: .type, value: nil)
    
    
    //MARK: - Getters
    func getSingleAttributes() -> [SingleAttribute] {
        return [
            title,
            description,
            creationDate,
            typeData,
        ]
    }
    
}
