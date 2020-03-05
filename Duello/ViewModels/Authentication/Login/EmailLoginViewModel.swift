//
//  EmailLoginViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class EmailLoginViewModel: EmailLoginDisplayer {
    
    //MARK: - Variables
    private var loginUser = RawEmailUser()
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var password: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var email: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var emailIsValid: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var isLoggingIn = BehaviorRelay(value: false)
    var userIsLoggedIn = BehaviorRelay(value: false)
    var loginTapped: PublishRelay<Void> = PublishRelay<Void>()
    var clearTextEntries: PublishRelay<Void> = PublishRelay<Void>()
    
    //MARK: - Setup
    init() {
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Methods
    private func dataIsValid() -> Bool {
        if !emailIsValid.value {
            let authError = AuthenticationError.invalidEmail
            alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
            return false
        }
        return true
    }
    
    //MARK: - Networking
    private func performEmailLogin() {
        guard dataIsValid() else { return }
        
        loginUser.configure(viewModel: self)
        
        isLoggingIn.accept(true)
        AuthenticationService.shared.loginByEmail(loginUser: loginUser).subscribe(onNext: { [weak self] (success) in
            self?.isLoggingIn.accept(false)
            self?.userIsLoggedIn.accept(true)
            self?.clearTextEntries.accept(())
            }, onError: { [weak self] (error) in
                self?.isLoggingIn.accept(false)
                if let authError = error as? AuthenticationError {
                    self?.alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
                }
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        email.map { (email) -> Bool in
            guard let email = email else { return false }
            return email.isValidEmailAddress()
            }.bind(to: emailIsValid).disposed(by: disposeBag)
        
        loginTapped.subscribe { [weak self] (_) in
            self?.performEmailLogin()
            }.disposed(by: disposeBag)
    }
    
}
