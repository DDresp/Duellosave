//
//  UploadingService_Post.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift

extension UploadingService {
    
    func create(post: PostModel) -> Observable<PostModel?> {
        let id = UUID().uuidString
        return savePost(post: post, postId: id)
    }
    
    func updatePost(post: PostModel) -> Observable<PostModel?> {
        return savePost(post: post, postId: post.getId())
    }
    
    private func savePost(post: PostModel, postId: String) -> Observable<PostModel?> {
        guard hasInternetConnection() else { return Observable.error(UploadingError.networkError)}
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(UploadingError.userNotLoggedIn)}
        
        return FetchingService.shared.fetchUser(for: uid).flatMapLatest { [weak self] (user) -> Observable<PostModel?> in
            guard let self = self else { return Observable.empty() }
            post.user.model = user
            return self.saveDatabaseModel(databaseModel: post, reference: POST_REFERENCE, id: postId).map { (post) -> PostModel in
                guard let savedPost = post as? PostModel else { throw UploadingError.unknown(description: "unknown error")}
                return savedPost
            }
        }
    }
    
}
