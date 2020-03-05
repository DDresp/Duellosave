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
    
    func fetchPosts(from reference: CollectionReference ,orderKey: String, limit: Int, startId: String?) -> Observable<[PostModel]> {
        
        return fetchIds(reference: reference, orderKey: orderKey, limit: limit, startId: startId).flatMap { (postIds) in
            return Observable.from(postIds)
            }.flatMap { (postId) -> Observable<PostModel> in
                return self.fetchPost(for: postId)
            }.toArray()
    }
    
}
