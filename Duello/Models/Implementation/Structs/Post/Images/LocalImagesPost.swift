//
//  LocalImagesPost.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

struct LocalImagesPost: LocalImagesPostModel {
    
    //MARK: - Variables
    var id: String?
    var name = "LocalImage"
    
    //MARK: - Attributes
    var uid: PostAttribute = PostAttribute(attributeCase: .uid, value: nil)
    var cid: PostAttribute = PostAttribute(attributeCase: .cid, value: nil)
    var title: PostAttribute = PostAttribute(attributeCase: .title, value: nil)
    var description: PostAttribute = PostAttribute(attributeCase: .description, value: nil)
    var creationDate: PostAttribute = PostAttribute(attributeCase: .creationDate, value: nil)
    var likes: PostAttribute = PostAttribute(attributeCase: .likes, value: nil)
    var dislikes: PostAttribute = PostAttribute(attributeCase: .dislikes, value: nil)
    var rate: PostAttribute = PostAttribute(attributeCase: .rate, value: nil)
    var mediaRatio: PostAttribute = PostAttribute(attributeCase: .mediaRatio, value: nil)
    var isDeactivated: PostAttribute = PostAttribute(attributeCase: .isDeactivated, value: false)
    var isInappropriate: PostAttribute = PostAttribute(attributeCase: .isInappropriate, value: false)
    var isInWrongCategory: PostAttribute = PostAttribute(attributeCase: .isInWrongCategory, value: false)
    var isFromFakeUser: PostAttribute = PostAttribute(attributeCase: .isFromFakeUser, value: false)
    var imageUrls: PostAttribute = PostAttribute(attributeCase: .imageUrls, value: [String]())
    var typeData: PostAttribute = PostAttribute(attributeCase: .type, value: FineMediaType.localImages)
    
    var user: PostReference = PostReference(attributeCase: .user, model: User())
    var category: PostReference = PostReference(attributeCase: .category, model: Category())
    
    //MARK: - Getters
    
    func getAttributes() -> [ModelAttribute] {
        return [
            uid,
            cid,
            title,
            description,
            creationDate,
            likes,
            dislikes,
            rate,
            typeData,
            mediaRatio,
            isDeactivated,
            imageUrls,
            isInappropriate,
            isInWrongCategory,
            isFromFakeUser
        ]
    }
    
    func getReferences() -> [ModelReference]? {
        return [user, category]
    }
    
}
