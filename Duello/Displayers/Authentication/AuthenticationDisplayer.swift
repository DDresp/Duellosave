//
//  AuthenticationDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AuthenticationDisplayer: class {
    
    //MARK: - ChildDisplayers
    var forgotPasswordDisplayer: ForgotPasswordDisplayer { get }
    var googleLoginDisplayer: GoogleLoginDisplayer { get }
    var facebookLoginDisplayer: FacebookLoginDisplayer { get }
    var emailLoginDisplayer: EmailLoginDisplayer { get }
    var registrationDisplayer: RegistrationDisplayer { get }
    
    //MARK: - Variables
    var progressHudMessage: String? { get }
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var isScrolledUp: BehaviorRelay<Bool> { get }
    
    var showLoginView: BehaviorRelay<Bool> { get }
    var showRegistrationView: BehaviorRelay<Bool> { get }
    var showForgotPasswordView: BehaviorRelay<Bool> { get }
    
    var signUpTapped: PublishRelay<Void> { get }
    var signInTapped: PublishRelay<Void> { get }
    var facebookTapped: PublishRelay<Void> { get }
    var googleTapped: PublishRelay<Void> { get }
    var forgotPasswordTapped: PublishRelay<Void> { get }
    var phoneTapped: PublishRelay<Void> { get }
    
    var forgotPasswordDismissed: PublishRelay<Void> { get }
    var clearTextEntries: PublishRelay<Void> { get }
    
    //MARK: - Methods
    func keyboardWillShow()
    func keyboardWillHide()
    
}
