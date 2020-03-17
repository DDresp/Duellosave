//
//  InstagramSingleImagePost.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

struct InstagramSingleImagePost: InstagramSingleImagePostModel {
    
    //MARK: - Variables
    var id: String?
    var name = "InstagramSingleImagePost"
    
    //MARK: - Attributes
    var uid: PostSingleAttribute = PostSingleAttribute(attributeCase: .uid, value: nil)
    var title: PostSingleAttribute = PostSingleAttribute(attributeCase: .title, value: nil)
    var description: PostSingleAttribute = PostSingleAttribute(attributeCase: .description, value: nil)
    var creationDate: PostSingleAttribute = PostSingleAttribute(attributeCase: .creationDate, value: nil)
    var likes: PostSingleAttribute = PostSingleAttribute(attributeCase: .likes, value: nil)
    var dislikes: PostSingleAttribute = PostSingleAttribute(attributeCase: .dislikes, value: nil)
    var rate: PostSingleAttribute = PostSingleAttribute(attributeCase: .rate, value: nil)
    var isDeactivated: PostSingleAttribute = PostSingleAttribute(attributeCase: .isDeactivated, value: false)
    
    var typeData: PostSingleAttribute = PostSingleAttribute(attributeCase: .type, value: MediaType.instagramSingleImage)
    var apiUrl: PostSingleAttribute = PostSingleAttribute(attributeCase: .apiUrl, value: nil)
    
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
            apiUrl,
            isDeactivated
        ]
    }
    
    //MARK: - Networking
    func downloadSingleImageUrl() -> Observable<URL?> {
        
        guard let apiUrlString = apiUrl.value?.toStringValue() else {
            return Observable.empty()
        }
        return InstagramService.shared.downloadInstagramImagesPost(from: apiUrlString).map({ (rawInstagramImagesPost) -> URL? in
            if let post = rawInstagramImagesPost as? RawInstagramSingleImagePost {
                return post.singleImageUrl
            } else {
                return nil
            }
        })
    }

}
