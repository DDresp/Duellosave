//
//  GoogleLoginViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase
import GoogleSignIn

class GoogleLoginViewModel: NSObject, GoogleLoginDisplayer, GIDSignInDelegate {
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var isLoggingIn = BehaviorRelay(value: false)
    var userIsLoggedIn = BehaviorRelay(value: false)
    var started = PublishSubject<Void>()
    
    //MARK: - Setup
    override init() {
        super.init()
        GIDSignIn.sharedInstance().delegate = self
        setupBindablesFromSelf()
    }
    
    //MARK: - Delegation
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            self.isLoggingIn.accept(false)
            return
        }
        
        guard let idToken = user.authentication.idToken else {
            self.isLoggingIn.accept(false)
            return }
        guard let accessToken = user.authentication.accessToken else {
            self.isLoggingIn.accept(false)
            return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        AuthenticationService.shared.loginByCredential(credential: credential).subscribe(onNext: { [weak self] (success) in
            self?.isLoggingIn.accept(false)
            if success {
                self?.userIsLoggedIn.accept(true)
            }
            }, onError: { [weak self] (error) in
                self?.isLoggingIn.accept(false)
                if let authError = error as? AuthenticationError {
                    self?.alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
                }
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Networking
    func performGoolgeLogin() {
        self.isLoggingIn.accept(true)
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromSelf() {
        
        started.asObservable().subscribe { [weak self] (_) in
            self?.performGoolgeLogin()
            }.disposed(by: disposeBag)
        
    }
    
}
