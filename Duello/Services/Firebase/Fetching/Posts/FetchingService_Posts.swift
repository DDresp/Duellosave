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
    
    func fetchPosts(field: String, key: String, orderKey: String, limit: Int?, startId: String?) -> Observable<[PostModel]> {
        
        return fetchDocuments(for: POST_REFERENCE, field: field, key: key, orderKey: orderKey, limit: limit, startId: startId).map { (docs) -> [PostModel] in
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
//        return Observable.create { (observer) -> Disposable in
//
//            var query = POST_REFERENCE.whereField(field, isEqualTo: key).order(by: orderKey, descending: true)
//
//            if let id = startId, let document = MemoryManager.shared.retrieveSnapshot(from: key + POST_REFERENCE.document(id).path) {
//                query = query.start(afterDocument: document)
//            }
//
//            if let limit = limit {
//                query = query.limit(to: limit)
//            }
//
//            query.getDocuments { (snapshot, err) in
//                if let err = err {
//                    observer.onError(DownloadError(error: err))
//                    return
//                }
//
//                guard let documents = snapshot?.documents else {
//                    return observer.onError(DownloadError.noData)
//                }
//
//                var posts = [PostModel]()
//                for document in documents {
//                    let data = document.data()
//                    if let post = self.configurePost(data: data, postId: document.documentID) {
//                        posts.append(post)
//                    }
//                }
//
//                if let lastDocument = documents.last {
//                    let lastId = lastDocument.documentID
//                    MemoryManager.shared.memorize(snapshot: lastDocument, with: key + POST_REFERENCE.document(lastId).path)
//                }
//
//                observer.onNext(posts)
//                observer.onCompleted()
//            }
//            return Disposables.create()
//        }
        
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
            ()
        }
        
        post?.configure(with: data, id: postId)
        return post
        
    }
    
//    func fetchPosts(from reference: CollectionReference ,orderKey: String, limit: Int, startId: String?) -> Observable<[PostModel]> {
//
//        return fetchIds(reference: reference, orderKey: orderKey, limit: limit, startId: startId).flatMap { (postIds) in
//            return Observable.from(postIds)
//            }.flatMap { (postId) -> Observable<PostModel> in
//                return self.fetchPost(for: postId)
//            }.toArray()
//    }
    
}
