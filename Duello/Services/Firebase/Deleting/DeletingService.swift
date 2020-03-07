//
//  DeletingService.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import FirebaseFirestore
import RxSwift
import Alamofire


class DeletingService: NetworkService {
    
    static let shared = DeletingService()
    
    private init() {}
    
    func deletePost(for postId: String) -> Observable<Void> {
        
        if !hasInternetConnection() { return Observable.error(DeletingError.networkError) }
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(UploadingError.userNotLoggedIn)}
        
        return deleteUserPostReference(uid: uid, postId: postId).asObservable().flatMap({ (_) -> Observable<Void> in
            return self.deletePostReference(for: postId)})
    }
    
    private func deletePostReference(for postId: String) -> Observable<Void> {
        
        return Observable.create({ (observer) -> Disposable in
    
            POST_REFERENCE.document(postId).delete(completion: { (err) in
                if let err = err {
                    observer.onError(UploadingError.init(error: err))
                    return
                }
                
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    private func deleteUserPostReference(uid: String, postId: String) -> Observable<Void> {
        
        return Observable.create({ (observer) -> Disposable in
            USER_POST_REFERENCE.document(uid).collection("posts").document(postId).delete(completion: { (err) in
                if let err = err {
                    observer.onError(UploadingError.init(error: err))
                    return
                }
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}
