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
    
//    func fetchPosts(for uid: String, limit: Int, startId: String) -> Observable<[PostModel]> {
//        
//        return fetchNewPosts(for: uid, limit: limit, startId: startId)
////        let reference = USER_POST_REFERENCE.document(uid).collection("posts")
////        let orderKey = "creationDate"
////
////        return fetchPosts(from: reference, orderKey: orderKey, limit: limit, startId: postId).map { (posts) -> [PostModel] in
////            var orderedPosts = posts
////            orderedPosts.sort(by: { (post1, post2) -> Bool in
////                guard let creationDate1 = Double(post1.creationDate.value?.toStringValue() ?? "0") else { return true }
////                guard let creationDate2 = Double(post2.creationDate.value?.toStringValue() ?? "0") else { return true }
////                return (creationDate1 > creationDate2)
////            })
////            return orderedPosts
////        }
//    }
    
    func fetchUserPosts(for uid: String, limit: Int?, startId: String?) -> Observable<[PostModel]> {
        return fetchPosts(field: "uid", key: uid, orderKey: "creationDate", limit: limit, startId: startId).map { (posts) -> [PostModel] in
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
    
    
//    func fetchUserFootprint(for uid: String) -> Observable<RawUserPostsFootprint> {
//        return Observable.create({ (observer) -> Disposable in
//            POST_REFERENCE.whereField("uid", isEqualTo: uid).getDocuments { (snapshot, err) in
//                if let err = err {
//                    observer.onError(DownloadError.unknown(description: err.localizedDescription))
//                    return
//                }
//                guard let snapshot = snapshot else {
//                    observer.onError(DownloadError.unknown(description: "unknown error"))
//                    return
//                }
//                var totalLikes: Double = 0
//                var totalDislikes: Double = 0
//                for document in snapshot.documents {
//                    let data = document.data()
//                    let likes = data["likes"] as? Double ?? 0
//                    let dislikes = data["dislikes"] as? Double ?? 0
//                    totalLikes = totalLikes + likes
//                    totalDislikes = totalDislikes + dislikes
//                }
//                let rate: Double
//
//                if (totalDislikes + totalLikes == 0) {
//                    rate = 0.5
//                } else {
//                    rate = totalLikes / (totalDislikes + totalLikes)
//                }
//                observer.onNext(RawUserPostsFootprint(numberOfPosts: 0, score: rate))
//                observer.onCompleted()
//            }
//            return Disposables.create()
//        })
//
//        return fetchDic(for: USER_POST_REFERENCE, id: uid).map { (data) -> RawUserPostsFootprint in
//            //default values
//            guard let data = data else { return RawUserPostsFootprint(numberOfPosts: 0, score: 0.5) }
//            return self.configureUserPostsFootprint(for: data)
//        }
//    }
    
    
//    func fetchUserFootprint(for uid: String) -> Observable<RawUserPostsFootprint> {
//        return fetchDic(for: USER_POST_REFERENCE, id: uid).map { (data) -> RawUserPostsFootprint in
//            //default values
//            guard let data = data else { return RawUserPostsFootprint(numberOfPosts: 0, score: 0.5) }
//            return self.configureUserPostsFootprint(for: data)
//        }
//    }

//    private func configureUserPostsFootprint(for data: [String: Any]) -> RawUserPostsFootprint {
//
//        let count = data["count"] as? Int ?? 0
//        let dislikes = data["dislikes"] as? Int ?? 0
//        let likes = data["likes"] as? Int ?? 0
//
//        if (likes + dislikes) == 0 { return RawUserPostsFootprint(numberOfPosts: count, score: 0.5) }
//        let rate = Double(likes) / (Double(likes) + Double(dislikes))
//        return RawUserPostsFootprint(numberOfPosts: count, score: rate)
//
//    }
//
}
