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
    var imageUrl: CategoryAttribute = CategoryAttribute(attributeType: .imageUrl, value: nil)
    var title: CategoryAttribute = CategoryAttribute(attributeType: .title, value: nil)
    var description: CategoryAttribute = CategoryAttribute(attributeType: .description, value: nil)
    var creationDate: CategoryAttribute = CategoryAttribute(attributeType: .creationDate, value: nil)
    var roughMediaType: CategoryAttribute = CategoryAttribute(attributeType: .mediaType, value: nil)
    var reportStatus: CategoryAttribute = CategoryAttribute(attributeType: .reportStatus, value: CategoryReportStatusEnum.noReport)
    var numberOfPosts: CategoryAttribute = CategoryAttribute(attributeType: .numberOfPosts, value: 0)
    var uid: CategoryAttribute = CategoryAttribute(attributeType: .uid, value: nil)
    var isActive: CategoryAttribute = CategoryAttribute(attributeType: .isActive, value: false)
    
}
