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
    
    func savePost(post: PostModel, postId: String? = nil) -> Observable<PostModel?> {
        guard hasInternetConnection() else { return Observable.error(UploadingError.networkError)}
        let id: String = postId ?? UUID().uuidString
        
        return saveDatabaseModel(databaseModel: post, reference: POST_REFERENCE, id: id)
            .flatMap({ (databaseModel) -> Observable<PostModel?> in
            guard let savedPost = databaseModel as? PostModel else {
                throw UploadingError.unknown(description: "unknown error")
            }
            return self.saveUserPostQueryRelation(savedPost: savedPost, postId: id)
        })
        
    }
    
    private func saveUserPostQueryRelation(savedPost: PostModel, postId: String) -> Observable<PostModel?> {
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(UploadingError.userNotLoggedIn)}
        
        return saveQueryRelation(databaseModel: savedPost, reference: USER_POST_REFERENCE, fromId: uid, collectionName: "posts", toId: postId)
            .map({ (success) -> PostModel? in
            return success ? savedPost : nil
        })}
    
}
