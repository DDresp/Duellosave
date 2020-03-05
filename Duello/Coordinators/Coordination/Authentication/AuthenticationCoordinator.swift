//
//  AuthenticationCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift
import RxCocoa

class AuthenticationCoordinator: AuthenticationCoordinatorType {
    
    //MARK: - ChildCoordinators
    var phoneLoginCoordinator: AuthenticationPhoneLoginCoordinator?
    var userUploadCoordinator: AuthenticationUserUploadCoordinator?
    
    //MARK: - ViewModels
    private let facebookLoginViewModel = FacebookLoginViewModel() //Need facebook Login ViewModel here because we have to set the presented ViewController to the Facebook Login Process
    
    lazy private var authenticationViewModel: AuthenticationViewModel = {
        let viewModel = AuthenticationViewModel(facebookViewModel: facebookLoginViewModel)
        viewModel.coordinator = self
        return viewModel
    }()
    
    //MARK: - Variables
    private let defaults = UserDefaults.standard
    
    //MARK: - Bindables
    var loggedIn = PublishSubject<Void>()
    var phoneLoginRequested = PublishSubject<Void>()
    var authenticationCompleted = PublishSubject<Void>()
    
    //MARK: - Setup
    init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Getters
    private var didSetProfileSettingsOnDevice: Bool {
        guard let userId = Auth.auth().currentUser?.uid else { return false}
        return defaults.bool(forKey: userId)
    }
    
    //MARK: - Methods
    func start() {
        presentedController = AuthenticationController(viewModel: authenticationViewModel)
        facebookLoginViewModel.viewControllerFacebookLogin = presentedController
        rootController.present(presentedController!, animated: true)
        setupBindables()
    }
    
    private func performUserLoggedIn () {
        
        if didSetProfileSettingsOnDevice {
            authenticationCompleted.onNext(())
        } else {
            
            //Need Internet Connection. We try to fetch the username from the Database and check therefor wether the profileSettings might have been completed on a different device
            AuthenticationService.shared.checkDidSetProfileSettings().subscribe(onNext: { [weak self] (didSetProfileSettings) in
                if didSetProfileSettings {
                    guard let userId = Auth.auth().currentUser?.uid else { return }
                    self?.defaults.set(true, forKey: userId)
                    self?.authenticationCompleted.onNext(())
                } else {
                    self?.goToUploadUser()
                }
                }, onError: { [weak self] (error) in
                    if let authError = error as? AuthenticationError {
                        guard let presentedViewController = self?.presentedController as? AuthenticationController else { return }
                        presentedViewController.presentOneButtonAlert(header: authError.errorHeader, message: authError.errorMessage, buttonTitle: "OK", action: nil)
                        
                    }
            }).disposed(by: disposeBag)
        }
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindables() {
        
        loggedIn.subscribe(onNext: { [weak self] (_) in
            self?.performUserLoggedIn()
        }).disposed(by: disposeBag)
        
        phoneLoginRequested.subscribe (onNext: { [weak self] (phoneLoginRequested) in
            self?.goToPhoneLogin()
        }).disposed(by: disposeBag)
        
    }
    
}

//MARK: - Extension: PhoneLogin
extension AuthenticationCoordinator {
    
    //GoTo
    private func goToPhoneLogin() {
        
        guard let rootViewController = presentedController else { return }
        phoneLoginCoordinator = AuthenticationPhoneLoginCoordinator(rootController: rootViewController)
        phoneLoginCoordinator?.start()
        setupPhoneLoginBindables()
        
    }
    
    //Reactive
    private func setupPhoneLoginBindables() {
        guard let phoneLoginCoordinator = phoneLoginCoordinator else { return }
        
        phoneLoginCoordinator.loggedIn.asObservable().bind(to: loggedIn).disposed(by: disposeBag)
        
        Observable.of(phoneLoginCoordinator.loggedIn, phoneLoginCoordinator.canceledPhoneLogin).merge().subscribe(onNext: { [weak self] (_) in
            self?.phoneLoginCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
            self?.phoneLoginCoordinator = nil
        }).disposed(by: disposeBag)
        
    }
    
}

//MARK: - Extension: UploadUser
extension AuthenticationCoordinator {
    
    //GoTo
    private func goToUploadUser() {
        
        guard let rootViewController = presentedController else { return }
        userUploadCoordinator = AuthenticationUserUploadCoordinator(rootController: rootViewController)
        userUploadCoordinator?.start()
        setupUploadUserBindables()
        
    }
    
    //Reactive
    private func setupUploadUserBindables() {
        guard let uploadUserCoordinator = userUploadCoordinator else { return }
        
        uploadUserCoordinator.canceledUserUpload.asObservable().subscribe(onNext: { [weak self] (_) in
            do {
                try Auth.auth().signOut()
            } catch let err {
                print("failed to logout the user", err)
            }
            self?.userUploadCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
            self?.userUploadCoordinator = nil
            
        }).disposed(by: disposeBag)
        
        uploadUserCoordinator.didSetUser.asObservable().subscribe(onNext: { [weak self] (_) in
            guard let userId = Auth.auth().currentUser?.uid else { return }
            self?.defaults.set(true, forKey: userId)
            self?.authenticationCompleted.onNext(())
            self?.userUploadCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
            self?.userUploadCoordinator = nil
        }).disposed(by: disposeBag)
    }
    
}
