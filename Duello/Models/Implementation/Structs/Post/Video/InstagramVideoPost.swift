//
//  InstagramVideoPost.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

struct InstagramVideoPost: InstagramVideoPostModel {
    
    //MARK: - Variables
    var id: String?
    var name = "InstagramVideo"
    
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
    
    var typeData: PostSingleAttribute = PostSingleAttribute(attributeCase: .type, value: FineMediaType.instagramVideo)
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
            mediaRatio,
            isDeactivated
        ]
    }
    
    func getMapAttributes() -> [MapAttribute]? {
        return [user]
    }
    
    //MARK: - Networking
    func downloadVideoUrlAndThumbnail() -> Observable<(URL?, URL?)> {
        
        guard let apiUrlString = apiUrl.value?.toStringValue() else {
            return Observable.empty()
        }

        return InstagramService.shared.downloadInstagramVideoPost(from: apiUrlString).map({ (rawInstagramVideoPost) -> (URL, URL) in
            return (rawInstagramVideoPost.videoURL, rawInstagramVideoPost.thumbnailUrl)
        })
    }
    
}
