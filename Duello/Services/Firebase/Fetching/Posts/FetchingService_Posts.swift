//
//  FetchingService_Posts.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import Firebase
import FirebaseFirestore

extension FetchingService {
    
    func fetchPosts(orderKey: String, limit: Int?, startId: String?, equalityConditions: [String: Any]? = nil) -> Observable<[PostModel]> {
        return fetchDocuments(for: POST_REFERENCE, orderKey: orderKey, limit: limit, startId: startId, equalityConditions: equalityConditions).map { (docs) -> [PostModel] in
            guard let documents = docs else { throw DownloadError.noData }
            var posts = [PostModel]()
            for document in documents {
                let data = document.data()
                let id = document.documentID
                if let post = self.configurePost(data: data, postId: id) {
                    posts.append(post)
                }
            }
            return posts
        }
    }
    
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
    
        guard let mediaType = data[PostAttributeType.type.key] as? String else { return nil }
        
        var post: PostModel?
        
        switch mediaType {
        case FineMediaEnum.localImages.rawValue: post = LocalImagesPost()
        case FineMediaEnum.localSingleImage.rawValue: post = LocalSingleImagePost()
        case FineMediaEnum.localVideo.rawValue: post = LocalVideoPost()
        case FineMediaEnum.instagramVideo.rawValue: post = InstagramVideoPost()
        case FineMediaEnum.instagramSingleImage.rawValue: post = InstagramSingleImagePost()
        case FineMediaEnum.instagramImages.rawValue: post = InstagramImagesPost()
        default:
            ()
        }
        
        post?.decode(with: data, id: postId)
        return post
        
    }
    
}
