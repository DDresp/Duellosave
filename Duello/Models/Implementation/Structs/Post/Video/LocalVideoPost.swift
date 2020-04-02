//
//  LocalVideoPost.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

struct LocalVideoPost: LocalVideoPostModel {
    
    //MARK: - Variables
    var id: String?
    var name = "LocalVideoPost"
    
    //MARK: - Attributes
    var uid: PostSingleAttribute = PostSingleAttribute(attributeCase: .uid, value: nil)
    var title: PostSingleAttribute = PostSingleAttribute(attributeCase: .title, value: nil)
    var description: PostSingleAttribute = PostSingleAttribute(attributeCase: .description, value: nil)
    var creationDate: PostSingleAttribute = PostSingleAttribute(attributeCase: .creationDate, value: nil)
    var likes: PostSingleAttribute = PostSingleAttribute(attributeCase: .likes, value: nil)
    var dislikes: PostSingleAttribute = PostSingleAttribute(attributeCase: .dislikes, value: nil)
    var rate: PostSingleAttribute = PostSingleAttribute(attributeCase: .rate, value: nil)
    var mediaRatio: PostSingleAttribute = PostSingleAttribute(attributeCase: .mediaRatio, value: nil)
    var isDeactivated: PostSingleAttribute = PostSingleAttribute(attributeCase: .isDeactivated, value: false)
    var user: PostMapAttribute = PostMapAttribute(attributeCase: .user, model: User())
    
    var typeData: PostSingleAttribute = PostSingleAttribute(attributeCase: .type, value: FineMediaType.localVideo)
    var videoUrl: PostSingleAttribute = PostSingleAttribute(attributeCase: .videoUrl, value: nil)
    var thumbNailUrl: PostSingleAttribute = PostSingleAttribute(attributeCase: .thumbNailUrl, value: nil)
    
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
            videoUrl,
            thumbNailUrl,
            mediaRatio,
            isDeactivated
        ]
    }
    
    func getMapAttributes() -> [MapAttribute]? {
        return [user]
    }
}
