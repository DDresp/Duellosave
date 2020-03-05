//
//  FacebookLoginViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class FacebookLoginViewModel: FacebookLoginDisplayer {
    
    //MARK: - Variables
    weak var viewControllerFacebookLogin: UIViewController?
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var isLoggingIn = BehaviorRelay(value: false)
    var userIsLoggedIn = BehaviorRelay(value: false)
    var started = PublishSubject<Void>()
    
    //MARK: - Setup
    init() {
        setupBindablesFromSelf()
    }
    
    //MARK: - Networking
    func performFacebookLogin() {
        guard let viewController = viewControllerFacebookLogin else { return }

        isLoggingIn.accept(true)
        
        AuthenticationService.shared.loginByFacebook(from: viewController).subscribe(onNext: { [weak self] (success) in
            self?.isLoggingIn.accept(false)
            if success {
                self?.userIsLoggedIn.accept(true)
            }
        }, onError: { [weak self] (error) in
            self?.isLoggingIn.accept(false)
            if let authError = error as? AuthenticationError {
                switch authError {
                case .canceled: ()
                default:
                    self?.alert.accept(Alert(alertMessage: authError.errorMessage, alertHeader: authError.errorHeader))
                }
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromSelf() {
        
        started.asObservable().subscribe { [weak self] (_) in
            self?.performFacebookLogin()
            }.disposed(by: disposeBag)
    }
    
}
