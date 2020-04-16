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
    var typeData: PostAttribute = PostAttribute(attributeCase: .type, value: FineMediaType.instagramSingleImage)
    var apiUrl: PostAttribute = PostAttribute(attributeCase: .apiUrl, value: nil)
    var report: PostAttribute = PostAttribute(attributeCase: .report, value: ReportType.notReported)
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
            report
        ]
    }
    
    func getReferences() -> [ModelReference]? {
        return [user, category]
    }
    
    //MARK: - Networking
    func downloadSingleImageUrl() -> Observable<URL?> {
        
        guard let apiUrlString = apiUrl.value?.toStringValue() else {
            return Observable.empty()
        }
        return InstagramService.shared.downloadInstagramImagesPost(from: apiUrlString).map({ (rawInstagramImagesPost) -> (URL?) in
            if let post = rawInstagramImagesPost as? RawInstagramSingleImagePost {
                return post.singleImageUrl
            } else {
                return nil
            }
        })
    }

}
