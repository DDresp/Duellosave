//
//  PhoneLoginViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class PhoneLoginViewModel: PhoneLoginDisplayer {
    
    //MARK: - Coordinator
    weak var coordinator: AuthenticationPhoneLoginCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Variables
    var progressHudMessage: String? = "loading"
    var verificationId: String?
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var isLoading = BehaviorRelay(value: false)
    var cancelTapped: PublishSubject<Void> = PublishSubject<Void>()
    var phoneNumberSubmitTapped: PublishSubject<Void> = PublishSubject<Void>()
    var showPhoneNumberVerificationView: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var countryCode: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var phoneNumberWithoutCountryCode: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var verificationCode: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var verificationCodeSubmitTapped: PublishSubject<Void> = PublishSubject<Void>()
    
    //MARK: - Setup
    init() {
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Getters
    var phoneNumberString: String? {
        guard let countryCode = countryCode.value else { return nil }
        guard let phoneNumberWithoutCountryCode = phoneNumberWithoutCountryCode.value else { return nil }
        return countryCode + phoneNumberWithoutCountryCode
    }
    
    //MARK: - Networking
    private func performPhoneLogin() {
        
        guard let phoneNumberWithoutCode = phoneNumberWithoutCountryCode.value, phoneNumberWithoutCode.count > 0 else {
            let authError = AuthenticationError.invalidPhoneNumber
            alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
            return
        }
        guard let phoneNumberString = phoneNumberString else { return }
        isLoading.accept(true)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberString, uiDelegate: nil, completion: { [weak self] (verificationId, err) in
            self?.isLoading.accept(false)
            if let error = err {
                let authError = AuthenticationError(error: error)
                self?.alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
                return
            }
            self?.showPhoneNumberVerificationView.accept(true)
            self?.verificationId = verificationId
        })
    }
    
    //Check Verification Code
    private func performVerificationCodeCheck() {
        
        guard let verificationId = verificationId else {
            let authError = AuthenticationError.unknown(description: "unknown error, please try again")
            alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
            return
        }
        guard let code = verificationCode.value, code.count > 0 else {
            let authError = AuthenticationError.invalidVerificationCode
            alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
        
        isLoading.accept(true)
        
        AuthenticationService.shared.loginByCredential(credential: credential).subscribe(onNext: { [weak self] (success) in
            self?.isLoading.accept(false)
            if success {
                self?.coordinator?.loggedIn.accept(())
            }
            }, onError: { [weak self] (error) in
                self?.isLoading.accept(false)
                if let authError = error as? AuthenticationError {
                    self?.alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
                }
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        phoneNumberSubmitTapped.asObservable().subscribe { [weak self] (_) in
            self?.performPhoneLogin()
            }.disposed(by: disposeBag)
        
        verificationCodeSubmitTapped.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.performVerificationCodeCheck()
        }).disposed(by: disposeBag)
    }
    
    private func setupBindablesToCoordinator() {
        guard let coordinatorDelegate = coordinator else { return }
        cancelTapped.asObservable().bind(to: coordinatorDelegate.canceledPhoneLogin).disposed(by: disposeBag)
    }
        
}
