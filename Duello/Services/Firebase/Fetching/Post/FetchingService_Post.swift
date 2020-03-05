//
//  FetchingService_Post.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import Firebase

extension FetchingService {
    
    func fetchPost(for postId: String) -> Observable<PostModel> {
        return fetchDic(for: POST_REFERENCE, id: postId)
            .map { (data) -> PostModel? in
                guard let data = data else { throw DownloadError.noData }
                return self.configurePost(data: data, postId: postId)
            }.map { (post) -> PostModel in
                guard let post = post else { throw DownloadError.unknown(description: "unknown error") }
                return post
        }
    }
    
    func configurePost(data: [String: Any], postId: String) -> PostModel? {

        guard let mediaType = data[PostSingleAttributeCase.type.key] as? String else { return nil }
        
        var post: PostModel?
        
        switch mediaType {
        case MediaType.localImages.rawValue: post = LocalImagesPost()
        case MediaType.localSingleImage.rawValue: post = LocalSingleImagePost()
        case MediaType.localVideo.rawValue: post = LocalVideoPost()
        case MediaType.instagramVideo.rawValue: post = InstagramVideoPost()
        case MediaType.instagramSingleImage.rawValue: post = InstagramSingleImagePost()
        case MediaType.instagramImages.rawValue: post = InstagramImagesPost()
        default:
            print("debug developing: MEDIATYPE not found while configuring the post")
        }
        
        post?.configure(with: data, id: postId)
        return post
        
    }
    
}
