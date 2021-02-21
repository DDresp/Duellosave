//
//  UploadingService_User.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import Firebase

extension UploadingService {
    
    func saveUser(userProfile: UserModel, shouldUpdate: Bool) -> Observable<UserModel?> {
        guard hasInternetConnection() else { return Observable.error(UploadingError.networkError)}
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(UploadingError.userNotLoggedIn)}
        
        let updatingsPosts = FetchingService.shared.fetchAllUserPosts(for: uid).flatMapLatest { (posts, _) -> Observable<[PostModel?]> in
            return Observable.from(posts).flatMap { (post) -> Observable<PostModel?> in
                post.user.model = userProfile
                return self.updatePost(post: post)
            }.toArray()
        }
        let updatingUser = saveDatabaseModel(databaseModel: userProfile, reference: USERS_REFERENCE, id: uid, shouldUpdate: shouldUpdate)
        
        return Observable.zip(updatingsPosts, updatingUser).map { (posts, model) -> UserModel? in
            return model as? UserModel
        }
    }
    
}
