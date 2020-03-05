//
//  AppCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift
import RxCocoa

//MARK: - AppCoordinator
class AppCoordinator: AppCoordinatorType {
    
    //MARK: - ChildCoordinators
    private var authenticationCoordinator: AuthenticationCoordinator?
    private var mainCoordinator: MainCoordinator?
    
    //MARK: - Variables
    private var window: UIWindow
    private let defaults = UserDefaults.standard
    
    //MARK: - Setup
    init(window: UIWindow) {
        window.rootViewController = rootController
        self.window = window
    }
    
    //MARK: - Controllers
    private let rootController = RootController()
    
    //MARK: - Getters
    private var userIsLoggedIn: Bool {
        if let _ = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
    //If the user set the profile settings with a different device, "userDidSetProfileSettings" will be false on the current device. However otherwise we would have to check if the user did set the Profile Settings via information saved on a server and therefor the user would be required to have internet connection. Pros and Cons to each approach I guess.
    //WARNING: If user got deleted in the database this value is still true!
    private var userDidSetProfileSettingsOnThisDevice: Bool {
        guard let userId = Auth.auth().currentUser?.uid else { return false }
        return defaults.bool(forKey: userId)
    }
    
    //MARK: - Methods
    func start() {
        if userIsLoggedIn {
            goToMain()
        } else {
            goToAuthentication()
        }
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
}

//MARK: - Extension: LoginAndRegistration
extension AppCoordinator {
    
    //GoTo
    private func goToAuthentication() {
        mainCoordinator?.rootController.dismiss(animated: true)
        mainCoordinator = nil
        authenticationCoordinator = AuthenticationCoordinator(rootController: rootController)
        authenticationCoordinator?.start()
        setupAuthenticationBindables()
    }
    
    //Reactive
    private func setupAuthenticationBindables() {
        
        guard let authenticationCoordinator = authenticationCoordinator else { return }
        
        authenticationCoordinator.authenticationCompleted.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.goToMain()
        }).disposed(by: disposeBag)
        
    }
}

//MARK: - Extension: Main
extension AppCoordinator {
    
    //GoTo
    private func goToMain() {
        if !userDidSetProfileSettingsOnThisDevice {
            do {
                try Auth.auth().signOut()
            } catch let err {
                print("failed to logout the user", err)
            }
            goToAuthentication()
            return
        }
        authenticationCoordinator?.rootController.dismiss(animated: true)
        self.authenticationCoordinator = nil
        mainCoordinator = MainCoordinator(rootController: rootController)
        mainCoordinator?.start()
        setupMainBindables()
    }
    
    //Reactive
    private func setupMainBindables() {
        guard let mainCoordinator = mainCoordinator else { return }
        
        mainCoordinator.loggedOut.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.goToAuthentication()
        }).disposed(by: disposeBag)
    }
    
}
