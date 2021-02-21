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
    var uid: PostAttribute = PostAttribute(attributeType: .uid, value: nil)
    var cid: PostAttribute = PostAttribute(attributeType: .cid, value: nil)
    var title: PostAttribute = PostAttribute(attributeType: .title, value: nil)
    var description: PostAttribute = PostAttribute(attributeType: .description, value: nil)
    var creationDate: PostAttribute = PostAttribute(attributeType: .creationDate, value: nil)
    var likes: PostAttribute = PostAttribute(attributeType: .likes, value: nil)
    var dislikes: PostAttribute = PostAttribute(attributeType: .dislikes, value: nil)
    var rate: PostAttribute = PostAttribute(attributeType: .rate, value: nil)
    var mediaRatio: PostAttribute = PostAttribute(attributeType: .mediaRatio, value: nil)
    var isVerified: PostAttribute = PostAttribute(attributeType: .isVerified, value: false)
    var isBlocked: PostAttribute = PostAttribute(attributeType: .isBlocked, value: false)
    var isDeactivated: PostAttribute = PostAttribute(attributeType: .isDeactivated, value: false)
    var typeData: PostAttribute = PostAttribute(attributeType: .type, value: FineMediaEnum.instagramVideo)
    var apiUrl: PostAttribute = PostAttribute(attributeType: .apiUrl, value: nil)
    var reportStatus: PostAttribute = PostAttribute(attributeType: .reportStatus, value: PostReportStatusEnum.noReport)
    var user: PostReference = PostReference(referenceType: .user, model: User())
    var category: PostReference = PostReference(referenceType: .category, model: Category())
    
    //MARK: - Networking
    func downloadVideoUrlAndThumbnail() -> Observable<(URL?, URL?)> {
        
        let apiUrlString = getApiUrl()
        
        return InstagramService.shared.downloadInstagramVideoPost(from: apiUrlString).map({ (rawInstagramVideoPost) -> (URL, URL) in
            return (rawInstagramVideoPost.videoURL, rawInstagramVideoPost.thumbnailUrl)
        })
    }
    
}
