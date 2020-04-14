//
//  InstagramImagesPost.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

struct InstagramImagesPost: InstagramImagesPostModel {
    
    //MARK: - Variables
    var id: String?
    var name = "InstagramImage"
    
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
    var typeData: PostAttribute = PostAttribute(attributeCase: .type, value: FineMediaType.instagramImages)
    var isInappropriate: PostAttribute = PostAttribute(attributeCase: .isInappropriate, value: false)
    var isInWrongCategory: PostAttribute = PostAttribute(attributeCase: .isInWrongCategory, value: false)
    var isFromFakeUser: PostAttribute = PostAttribute(attributeCase: .isFromFakeUser, value: false)
    var apiUrl: PostAttribute = PostAttribute(attributeCase: .apiUrl, value: nil)
    
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
            apiUrl,
            mediaRatio,
            isDeactivated,
            isInappropriate,
            isInWrongCategory,
            isFromFakeUser
        ]
    }

    func getReferences() -> [ModelReference]? {
        return [user, category]
    }
    
    //MARK: - Networking
    func downloadImageUrls() -> Observable<([URL]?)> {
        guard let apiUrlString = apiUrl.value?.toStringValue() else {
            return Observable.empty()
        }
        
        return InstagramService.shared.downloadInstagramImagesPost(from: apiUrlString).map({ (rawInstagramImagesPost) -> ([URL]?) in
            if let post = rawInstagramImagesPost as? RawInstagramImagesPost {
                return post.imageUrls
            } else {
                return nil
            }
        })
    }
    
}
