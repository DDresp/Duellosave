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
        
        return Observable.create({ (observer) -> Disposable in
    
            POST_REFERENCE.document(postId).delete(completion: { (err) in
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
