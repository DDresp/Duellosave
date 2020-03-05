//
//  AuthenticationService_Login.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift
import FBSDKLoginKit
import GoogleSignIn

extension AuthenticationService {
    
    //MARK: - Email Login
    func loginByEmail(loginUser: RawEmailUser) -> Observable<Bool> {
        guard let email = loginUser.email else { return Observable.error(AuthenticationError.invalidEmail)}
        guard let password = loginUser.password else { return Observable.error(AuthenticationError.invalidPassword) }
        return emailLogin(email: email, password: password)
    }
    
    private func emailLogin(email: String, password: String) -> Observable<Bool>  {
        
        return Observable.create({ (observer) -> Disposable in
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                if let error = error {
                    observer.onError(AuthenticationError(error: error))
                    return
                }
                
                guard let user = result?.user else {
                    observer.onError(AuthenticationError.authenticationFailed)
                    return
                }
                
                if user.isEmailVerified {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    
                    do {
                        try Auth.auth().signOut()
                    } catch let err {
                        print("failed to logout the user", err)
                    }
                    
                    user.sendEmailVerification()
                    observer.onError(AuthenticationError.verificationNeeded)
                    return
                }
                
            })
            
            return Disposables.create()
        })
    }
    
    //MARK: - Credential Login
    func loginByCredential(credential: AuthCredential) -> Observable<Bool> {
        
        return Observable.create({ (observer) -> Disposable in
            
            Auth.auth().signIn(with: credential, completion: { (result, error) in
                if let error = error {
                    let authError = AuthenticationError(error: error)
                    observer.onError(authError)
                    
                } else {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            })
            
            return Disposables.create()
            
        })
    }
    
    //MARK: - Facebook Login
    func loginByFacebook(from viewController: UIViewController) -> Observable<Bool> {
        return retrieveFacebookCredential(from: viewController).flatMap({ (credential) in
            return self.loginByCredential(credential: credential)
        })
    }
    
    private func retrieveFacebookCredential(from viewController: UIViewController) -> Observable<AuthCredential> {
        
        return Observable.create({ (observer) -> Disposable in
            
            let facebookLoginManager = LoginManager()
            facebookLoginManager.logIn(permissions: [], from: viewController, handler: { (result, error) in
                if let error = error {
                    observer.onError(AuthenticationError(error: error))
                    return
                }
                
                if let result = result, !result.isCancelled {
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
                    observer.onNext(credential)
                } else if let result = result, result.isCancelled {
                    observer.onError(AuthenticationError.canceled)
                } else {
                    observer.onCompleted()
                }
                
            })
            
            return Disposables.create()
        })
        
    }

}
