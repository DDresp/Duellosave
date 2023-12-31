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
        equalityConstraints[PostAttributeType.uid.key] = uid
        
        
        
        return fetchPosts(orderKey: PostAttributeType.creationDate.key, limit: limit, startId: startId, equalityConditions: equalityConstraints).map { (posts) -> [PostModel] in
            var orderedPosts = posts
            orderedPosts.sort(by: { (post1, post2) -> Bool in
                let creationDate1 = post1.getCreationDate()
                let creationDate2 = post2.getCreationDate()
                return (creationDate1.dateValue() > creationDate2.dateValue())
            })
            return orderedPosts
        }
    }
    
    func fetchAllUserPosts(for uid: String) -> Observable<([PostModel], Double)> {
        return fetchUserPosts(for: uid, limit: nil, startId: nil).map { (orderedPosts) -> ([PostModel], Double) in
            let totalLikes = orderedPosts.map { (post) -> Double in
                return Double(post.getLikes())
            }.reduce(0, +)
            let totalDislikes = orderedPosts.map { (post) -> Double in
                return Double(post.getDislikes())
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
