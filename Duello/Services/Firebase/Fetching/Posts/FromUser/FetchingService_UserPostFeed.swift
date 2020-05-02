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
    
    func fetchUserPosts(for uid: String, limit: Int?, startId: String?) -> Observable<[PostModel]> {
        
        var equalityConstraints = [String: Any]()
        equalityConstraints[PostAttributeCase.uid.key] = uid
        
        return fetchPosts(orderKey: PostAttributeCase.creationDate.key, limit: limit, startId: startId, equalityConditions: equalityConstraints).map { (posts) -> [PostModel] in
            var orderedPosts = posts
            orderedPosts.sort(by: { (post1, post2) -> Bool in
                guard let creationDate1 = Double(post1.creationDate.value?.toStringValue() ?? "0") else { return true }
                guard let creationDate2 = Double(post2.creationDate.value?.toStringValue() ?? "0") else { return true }
                return (creationDate1 > creationDate2)
            })
            return orderedPosts
        }
    }
    
    func fetchAllUserPosts(for uid: String) -> Observable<([PostModel], Double)> {
        return fetchUserPosts(for: uid, limit: nil, startId: nil).map { (orderedPosts) -> ([PostModel], Double) in
            let totalLikes = orderedPosts.map { (post) -> Double in
                return Double(post.likes.value?.toStringValue() ?? "0") ?? 0
            }.reduce(0, +)
            let totalDislikes = orderedPosts.map { (post) -> Double in
                return Double(post.dislikes.value?.toStringValue() ?? "0") ?? 0
            }.reduce(0, +)
            let rate: Double
            if totalLikes + totalDislikes == 0 {
                rate = 0.5
            } else {
                rate = totalLikes / (totalDislikes + totalLikes)
            }
            return (orderedPosts, rate)
        }
    }

}
