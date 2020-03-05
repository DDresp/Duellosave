//
//  AuthenticationService.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift
import FBSDKLoginKit
import GoogleSignIn

class AuthenticationService: NetworkService {
    
    static let shared = AuthenticationService()
    
    private init() {}
    
    func checkDidSetProfileSettings() -> Observable<Bool> {
        
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(AuthenticationError.userNotLoggedIn) }
        return Observable.create({ (observer) -> Disposable in
            
            USERS_REFERENCE.document(uid).getDocument(completion: { (document, error) in
                if let error = error {
                    observer.onError(AuthenticationError.unknown(description: error.localizedDescription))
                    return
                }
                
                //check if we get a document for the userId in Firebase. If so, the user apparently already did set the Profile Settings.
                if let _ = document?.data() {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
                
            })
            
            return Disposables.create()
        })
    }
    
}
