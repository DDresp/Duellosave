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
        
        return saveDatabaseModel(databaseModel: post, reference: POST_REFERENCE, id: id).map { (post) -> PostModel in
            guard let savedPost = post as? PostModel else { throw UploadingError.unknown(description: "unknown error")}
            return savedPost
        }
    }
    
}
