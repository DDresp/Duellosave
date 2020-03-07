//
//  AuthenticationService_Register.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import Firebase

extension AuthenticationService {
    
    func registerByEmail(registrationUser: RawRegistrationUser) -> Observable<Bool> {
        guard let email = registrationUser.email else { return Observable.error(AuthenticationError.invalidEmail) }
        guard let password = registrationUser.password else { return Observable.error(AuthenticationError.invalidPassword) }
        
        return createUser(email: email, password: password)
    }
    
    private func createUser(email: String, password: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in

            Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                if let error = error {
                    observer.onError(AuthenticationError(error: error))
                    return
                }
                
                guard let user = result?.user else {
                    observer.onError(AuthenticationError.authenticationFailed)
                    return
                }
                
                user.sendEmailVerification(completion: { (error) in
                    if let error = error {
                        observer.onError(AuthenticationError(error: error))
                    }
                })
                
                //User should only be logged in after he validated the email
                do {
                    try Auth.auth().signOut()
                } catch let err {
                    print("failed to logout the user", err)
                }
                
                observer.onNext(true)
                observer.onCompleted()
                
            })
            
            return Disposables.create()
        })
    }
    
}

