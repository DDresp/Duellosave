//
//  AuthenticationViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class AuthenticationViewModel: AuthenticationDisplayer {
    
    //MARK: - Definitions
    enum Activated {
        case login
        case forgotPassword
        case registration
    }
    
    //MARK: - Coordinator
    weak var coordinator: AuthenticationCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - ChildViewModels
    let forgotPasswordDisplayer: ForgotPasswordDisplayer = ForgotPasswordViewModel()
    let facebookLoginDisplayer: FacebookLoginDisplayer
    let googleLoginDisplayer: GoogleLoginDisplayer = GoogleLoginViewModel()
    let emailLoginDisplayer: EmailLoginDisplayer = EmailLoginViewModel()
    let registrationDisplayer: RegistrationDisplayer = RegistrationViewModel()
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var isLoading = BehaviorRelay(value: false)
    var activatedView: BehaviorRelay<Activated> = BehaviorRelay<Activated>(value: .login)
    var isScrolledUp = BehaviorRelay(value: false)
    
    var showLoginView: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    var showRegistrationView: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var showForgotPasswordView: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var signInTapped: PublishRelay<Void> = PublishRelay<Void>()
    var signUpTapped: PublishRelay<Void> = PublishRelay<Void>()
    var facebookTapped: PublishRelay<Void> = PublishRelay<Void>()
    var googleTapped: PublishRelay<Void> = PublishRelay<Void>()
    var forgotPasswordTapped: PublishRelay<Void> = PublishRelay<Void>()
    var phoneTapped: PublishRelay<Void> = PublishRelay<Void>()
    var forgotPasswordDismissed: PublishRelay<Void> = PublishRelay<Void>()
    var clearTextEntries: PublishRelay<Void> = PublishRelay<Void>()
    
    //MARK: - Setup
    init(facebookViewModel: FacebookLoginDisplayer) {
        self.facebookLoginDisplayer = facebookViewModel
        setupBindablesFromChildViewModels()
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Getters
    var progressHudMessage: String? {
        switch activatedView.value {
        case .forgotPassword: return "sending reset password"
        case .login: return "logging in"
        case .registration: return "registering"
        }
    }
    
    //MARK: - Methods
    func keyboardWillShow() {
        switch activatedView.value {
        case .forgotPassword: isScrolledUp.accept(false)
        case .login, .registration: isScrolledUp.accept(true)
        }
    }
    
    func keyboardWillHide() {
        isScrolledUp.accept(false)
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromChildViewModels() {
        
        Observable.of(emailLoginDisplayer.clearTextEntries, registrationDisplayer.clearTextEntries).merge().bind(to: clearTextEntries).disposed(by: disposeBag)
        
        Observable.of(registrationDisplayer.alert, googleLoginDisplayer.alert, facebookLoginDisplayer.alert, emailLoginDisplayer.alert, forgotPasswordDisplayer.alert).merge().bind(to: alert).disposed(by: disposeBag)
        
        Observable.combineLatest(registrationDisplayer.isRegistering, emailLoginDisplayer.isLoggingIn, forgotPasswordDisplayer.isSendingResetEmail, googleLoginDisplayer.isLoggingIn, facebookLoginDisplayer.isLoggingIn) { (isRegistering, isEmailLoggingIn, isSendingResetEmail, isGoogleLoggingIn, isFacebookLoggingIn) -> Bool in
            return isRegistering || isEmailLoggingIn || isSendingResetEmail || isGoogleLoggingIn || isFacebookLoggingIn
            }.bind(to: isLoading).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesFromOwnProperties() {
        
        facebookTapped.asObservable().bind(to: facebookLoginDisplayer.started).disposed(by: disposeBag)
        googleTapped.asObservable().bind(to: googleLoginDisplayer.started).disposed(by: disposeBag)
        
        signUpTapped.asObservable().map { (_) -> Activated in
            return .registration
            }.bind(to: activatedView).disposed(by: disposeBag)
        
        signInTapped.asObservable().map { (_) -> Activated in
            return .login
            }.bind(to: activatedView).disposed(by: disposeBag)
        
        Observable.combineLatest(signInTapped, signUpTapped) { (_, _) -> Bool in
            return false
            }.bind(to: isScrolledUp).disposed(by: disposeBag)
        
        forgotPasswordTapped.asObservable().map { (_) -> Activated in
            return .forgotPassword
            }.bind(to: activatedView).disposed(by: disposeBag)
        
        forgotPasswordDismissed.asObservable().map { (_) -> Activated in
            return .login
            }.bind(to: activatedView).disposed(by: disposeBag)
        
        activatedView.asObservable().map { (activatedView) -> Bool in
            return activatedView == .login ||  activatedView == .forgotPassword
            }.bind(to: showLoginView).disposed(by: disposeBag) //when forgot Password appears, the loginView should be still be displayed in the background
        
        activatedView.asObservable().map { (activatedView) -> Bool in
            return activatedView == .registration
            }.bind(to: showRegistrationView).disposed(by: disposeBag)
        
        activatedView.asObservable().map { (activatedView) -> Bool in
            return activatedView == .forgotPassword
            }.bind(to: showForgotPasswordView).disposed(by: disposeBag)
    }
    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        
        Observable.combineLatest(emailLoginDisplayer.userIsLoggedIn, facebookLoginDisplayer.userIsLoggedIn, googleLoginDisplayer.userIsLoggedIn) { (isEmailLoggedIn, isFacebookLoggedIn, isGoogleLoggedIn) -> Bool in
            return isEmailLoggedIn || isFacebookLoggedIn || isGoogleLoggedIn
            }.filter { (loggedIn) -> Bool in
                return loggedIn
            }.map { (_) -> Void in
                return Void()
            }.bind(to: coordinator.loggedIn).disposed(by: disposeBag)
        
        phoneTapped.bind(to: coordinator.phoneLoginRequested).disposed(by: disposeBag)
    }
    
}
