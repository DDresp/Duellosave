//
//  ForgotPasswordViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ForgotPasswordViewModel: ForgotPasswordDisplayer {
    
    //MARK: - Variables
    private var forgotPasswordUser = RawForgotPasswordUser()
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var email: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var emailIsValid: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var forgotPasswordSubmitTapped: PublishSubject<Void> = PublishSubject<Void>()
    var isSendingResetEmail = BehaviorRelay(value: false)
    
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
    private func performForgotPasswordEmail() {
        guard dataIsValid() else { return }
        
        isSendingResetEmail.accept(true)
        forgotPasswordUser.configure(viewModel: self)
        
        AuthenticationService.shared.performForgotPassword(forgotPasswordUser: forgotPasswordUser).subscribe(onNext: { [weak self] (_) in
            self?.isSendingResetEmail.accept(false)
            self?.alert.accept(Alert(alertMessage: "Please check your emails to reset your password. Please also look in your junk email folder.", alertHeader: "Password Reset Email Sent"))
            }, onError: { [weak self] (error) in
                self?.isSendingResetEmail.accept(false)
                if let authError = error as? AuthenticationError {
                    self?.alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
                }
                
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        email.asObservable().map { (email) -> Bool in
            guard let email = email else { return false }
            return email.isValidEmailAddress()
            }.bind(to: emailIsValid).disposed(by: disposeBag)
        
        forgotPasswordSubmitTapped.asObserver().subscribe { [weak self] (_) in
            self?.performForgotPasswordEmail()
            }.disposed(by: disposeBag)
        
    }
}
