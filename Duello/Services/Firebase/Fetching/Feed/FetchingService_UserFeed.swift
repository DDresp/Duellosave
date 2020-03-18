//
//  FetchingService_UserFeed.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift

extension FetchingService {
    
    func fetchPosts(for uid: String, at postId: String?, limit: Int) -> Observable<[PostModel]> {
        let reference = USER_POST_REFERENCE.document(uid).collection("posts")
        let orderKey = "creationDate"
        
        return fetchPosts(from: reference, orderKey: orderKey, limit: limit, startId: postId).map { (posts) -> [PostModel] in
            var orderedPosts = posts
            orderedPosts.sort(by: { (post1, post2) -> Bool in
                guard let creationDate1 = Double(post1.creationDate.value?.toStringValue() ?? "0") else { return true }
                guard let creationDate2 = Double(post2.creationDate.value?.toStringValue() ?? "0") else { return true }
                return (creationDate1 > creationDate2)
            })
            return orderedPosts
        }
    }
    
    func fetchUserFootprint(for uid: String) -> Observable<RawUserPostsFootprint> {
        return fetchDic(for: USER_POST_REFERENCE, id: uid).map { (data) -> RawUserPostsFootprint in
            //default values
            guard let data = data else { return RawUserPostsFootprint(numberOfPosts: 0, score: 0.5) }
            return self.configureUserPostsFootprint(for: data)
        }
    }
    
    private func configureUserPostsFootprint(for data: [String: Any]) -> RawUserPostsFootprint {
        
        let count = data["count"] as? Int ?? 0
        let dislikes = data["dislikes"] as? Int ?? 0
        let likes = data["likes"] as? Int ?? 0
        
        if (likes + dislikes) == 0 { return RawUserPostsFootprint(numberOfPosts: count, score: 0.5) }
        let rate = Double(likes) / (Double(likes) + Double(dislikes))
        return RawUserPostsFootprint(numberOfPosts: count, score: rate)
        
    }
    
}
