//
//  AuthenticationService_ForgotPassword.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import Firebase

//MARK: Forgot Password
extension AuthenticationService {
    
    func performForgotPassword(forgotPasswordUser: RawForgotPasswordUser) -> Observable<Bool> {
        
        guard let email = forgotPasswordUser.email else { return Observable.error(AuthenticationError.invalidEmail)}
        
        return Observable.create({ (observer) -> Disposable in
            
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    observer.onError(AuthenticationError(error: error))
                    return
                }
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
    
}
