//
//  RegistrationViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class RegistrationViewModel: RegistrationDisplayer {
    
    //MARK: - Variables
    private var registrationUser = RawRegistrationUser()
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var password: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var passwordIsValid = BehaviorRelay(value: false)
    var confirmedPassword: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var confirmedPasswordIsValid = BehaviorRelay(value: false)
    var email: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var emailIsValid = BehaviorRelay(value: false)
    var registrationTapped: PublishRelay<Void> = PublishRelay<Void>()
    var isRegistering = BehaviorRelay(value: false)
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
        if !passwordIsValid.value {
            let authError = AuthenticationError.invalidPassword
            alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
            return false
        }
        if !confirmedPasswordIsValid.value {
            let authError = AuthenticationError.invalidConfirmedPassword
            alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
            return false
        }
        return true
    }
    
    //MARK: - Networking
    private func performEmailRegistration() {
        guard dataIsValid() else { return }
        
        isRegistering.accept(true)
        registrationUser.configure(viewModel: self)
        
        AuthenticationService.shared.registerByEmail(registrationUser: registrationUser).subscribe(onNext: { [weak self] (_) in
            self?.isRegistering.accept(false)
            self?.alert.accept(Alert(alertMessage: "Please verify your email address by clicking on the link we send to your email address. Afterwards you will be able to login. Please also look in your junk email folder.", alertHeader: "Verify Email"))
            self?.clearTextEntries.accept(())
            },onError: { [weak self] (error) in
                self?.isRegistering.accept(false)
                if let authError = error as? AuthenticationError {
                    self?.alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
                }
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        password.asObservable().map { (password) -> Bool in
            guard let password = password else { return false}
            return password.isValidPassword()
            }.bind(to: passwordIsValid).disposed(by: disposeBag)
        
        Observable.combineLatest(password, confirmedPassword) { (password, confirmedPassword) -> Bool in
            if let password = password, let confirmedPassword = confirmedPassword, confirmedPassword.count > 0 {
                return password == confirmedPassword
            } else {
                return false
            }
            }.bind(to: confirmedPasswordIsValid).disposed(by: disposeBag)
        
        email.asObservable().map { (email) -> Bool in
            guard let email = email else { return false }
            return email.isValidEmailAddress()
            }.bind(to: emailIsValid).disposed(by: disposeBag)
        
        registrationTapped.asObservable().subscribe(onNext: { [weak self] (_) in
             self?.performEmailRegistration()
        }).disposed(by: disposeBag)
        
    }
}
