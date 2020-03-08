//
//  LocalSingleImagePost.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

struct LocalSingleImagePost: LocalSingleImagePostModel {
    
    //MARK: - Variables
    var id: String?
    var name = "Single Image"
    
    //MARK: - Attributes
    var uid: PostSingleAttribute = PostSingleAttribute(attributeCase: .uid, value: nil)
    var title: PostSingleAttribute = PostSingleAttribute(attributeCase: .title, value: nil)
    var description: PostSingleAttribute = PostSingleAttribute(attributeCase: .description, value: nil)
    var creationDate: PostSingleAttribute = PostSingleAttribute(attributeCase: .creationDate, value: nil)
    var likes: PostSingleAttribute = PostSingleAttribute(attributeCase: .likes, value: nil)
    var dislikes: PostSingleAttribute = PostSingleAttribute(attributeCase: .dislikes, value: nil)
    var rate: PostSingleAttribute = PostSingleAttribute(attributeCase: .rate, value: nil)
    
    var typeData: PostSingleAttribute = PostSingleAttribute(attributeCase: .type, value: MediaType.localSingleImage)
    var imageUrl: PostSingleAttribute = PostSingleAttribute(attributeCase: .imageUrl(0), value: nil)
    
    //MARK: - Getters
    func getSingleAttributes() -> [SingleAttribute] {
        return [
            uid,
            title,
            description,
            creationDate,
            likes,
            dislikes,
            rate,
            typeData,
            imageUrl
        ]
    }
    
}