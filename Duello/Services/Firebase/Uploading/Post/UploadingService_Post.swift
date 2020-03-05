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
    
    func savePost(post: PostModel) -> Observable<PostModel?> {
        guard hasInternetConnection() else { return Observable.error(UploadError.networkError)}
        let postId = UUID().uuidString
        
        return saveDatabaseModel(databaseModel: post, reference: POST_REFERENCE, id: postId)
            .flatMap({ (databaseModel) -> Observable<PostModel?> in
            guard let savedPost = databaseModel as? PostModel else {
                throw UploadError.unknown(description: "unknown error")
            }
            return self.saveUserPostQueryRelation(savedPost: savedPost, postId: postId)
        })
        
    }
    
    private func saveUserPostQueryRelation(savedPost: PostModel, postId: String) -> Observable<PostModel?> {
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(UploadError.userNotLoggedIn)}
        
        return saveQueryRelation(databaseModel: savedPost, reference: USER_POST_REFERENCE, fromId: uid, collectionName: "posts", toId: postId)
            .map({ (success) -> PostModel? in
            return success ? savedPost : nil
        })}
    
}
