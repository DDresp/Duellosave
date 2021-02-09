//
//  DeletingService_Unfollow.swift
//  Duello
//
//  Created by Darius Dresp on 8/11/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift
import RxCocoa

extension DeletingService {
    
    func unfavorCategory(categoryId: String) -> Observable<Void> {
        guard hasInternetConnection() else { return Observable.error(UploadingError.networkError)}
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(DeletingError.userNotLoggedIn)}
        
        let reference = USERS_REFERENCE.document(uid).collection(USER_FAVORITE_CATEGORIES_COLLECTION)
        
        return Observable.create({ (observer) -> Disposable in
            
            reference.document(categoryId).delete(completion: { (err) in
                if let err = err {
                    observer.onError(DeletingError.init(error: err))
                    return
                }
                
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
}

