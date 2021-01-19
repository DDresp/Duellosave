//
//  HomeCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
//

import RxCocoa
import RxSwift

class HomeCoordinator: HomeCoordinatorType {
    
    //MARK: - ChildCoordinators
    var homeSettingsCoordinator: HomeSettingsCoordinator?
    
    //MARK: - ViewModels
    lazy var viewModel: HomeViewModel = {
        let homeViewModel = HomeViewModel()
        homeViewModel.coordinator = self
        return homeViewModel
    }()
    
    //MARK: - Bindables
    var requestedLogout = PublishSubject<Void>()
    var requestedSettings = PublishSubject<UserModel>()
    
    //MARK: - Setup
    init() {
        let homeController = HomeController(viewModel: viewModel)
        presentedController = homeController
        let navController = UINavigationController(rootViewController: presentedController)
        navController.tabBarItem.title = "Home"
        navigationController = navController
        setupBindables()
    }
    
    //MARK: - Controllers
    var navigationController: UINavigationController?
    var presentedController: UIViewController!
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindables() {

        requestedSettings.subscribe {[weak self] (user) in
            self?.goToSettings(user: user)
        }.disposed(by: disposeBag)
        
    }
    
}

//MARK: - Extension: Settings
extension HomeCoordinator {
    
    //GoTo
    private func goToSettings(user: UserModel) {
        guard let rootController = presentedController else { return }
        homeSettingsCoordinator = HomeSettingsCoordinator(rootController: rootController, user: user)
        homeSettingsCoordinator?.start()
        setupBindablesFromSettings()
    }
    
    //Reactive
    private func setupBindablesFromSettings() {
        homeSettingsCoordinator?.requestedCancel.subscribe(onNext: { [weak self] (_) in
            self?.homeSettingsCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
            self?.homeSettingsCoordinator = nil
        }).disposed(by: disposeBag)
        
        homeSettingsCoordinator?.didSetUser.subscribe(onNext: { [weak self] (user) in
            self?.viewModel.forceFetchingAll = true
            self?.viewModel.homeCollectionViewModel.needsRestart.accept(true)
            self?.homeSettingsCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
            self?.homeSettingsCoordinator = nil
        }).disposed(by: disposeBag)
        
        homeSettingsCoordinator?.requestedLogout.bind(to: requestedLogout).disposed(by: disposeBag)
    }
    
}

//import RxCocoa
//import RxSwift
//
//class HomeCoordinator: HomeCoordinatorType {
//
//    //MARK: - ChildCoordinators
//    var homeUpdateUserCoordinator: HomeUpdateUserCoordinator?
//    var homeSettingsCoordinator: HomeSettingsCoordinator?
//
//    //MARK: - ViewModels
//    lazy var viewModel: HomeViewModel = {
//        let homeViewModel = HomeViewModel()
//        homeViewModel.coordinator = self
//        return homeViewModel
//    }()
//
//    //MARK: - Bindables
//    var requestedLogout = PublishSubject<Void>()
//    var requestedSettings = PublishSubject<UserModel>()
//
//    //MARK: - Setup
//    init() {
//        let homeController = HomeController(viewModel: viewModel)
//        presentedController = homeController
//        let navController = UINavigationController(rootViewController: presentedController)
//        navController.tabBarItem.title = "Home"
//        navigationController = navController
//        setupBindables()
//    }
//
//    //MARK: - Controllers
//    var navigationController: UINavigationController?
//    var presentedController: UIViewController!
//
//    //MARK: - Reactive
//    private let disposeBag = DisposeBag()
//
//    private func setupBindables() {
//        requestedSettings.subscribe(onNext: { [weak self] (user) in
//            self?.goToUpdateUser(user: user)
//        }).disposed(by: disposeBag)
//
//        requestedEditing.subscribe {[weak self] (user) in
//            self?.goToEditing(user: user)
//        }.disposed(by: disposeBag)
//
//    }
//
//}
//
////MARK: - Extension: UpdateUser
//extension HomeCoordinator {
//
//    //GoTo
//    private func goToUpdateUser(user: UserModel) {
//        guard let rootController = presentedController else { return }
//        //        guard let user = viewModel.homeCollectionViewModel.postHeaderDisplayer?.user.value else { return }
//        homeUpdateUserCoordinator = HomeUpdateUserCoordinator(rootController: rootController, user: user)
//        homeUpdateUserCoordinator?.start()
//        setupUpdateUserBindables()
//
//    }
//
//    private func goToEditing(user: UserModel) {
//        guard let rootController = presentedController else { return }
//        homeSettingsCoordinator = HomeSettingsCoordinator(rootController: rootController, user: user)
//        homeSettingsCoordinator?.start()
//        setupBindablesFromSettings()
//    }
//
//    //Reactive
//    private func setupUpdateUserBindables() {
//        homeUpdateUserCoordinator?.canceledUserUpload.asObservable().subscribe(onNext: { [weak self] (_) in
//            self?.homeUpdateUserCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
//            self?.homeUpdateUserCoordinator = nil
//
//        }).disposed(by: disposeBag)
//
//        homeUpdateUserCoordinator?.didSetUser.asObservable().subscribe(onNext: { [weak self] (user) in
//            self?.viewModel.forceFetchingAll = true
//            self?.viewModel.homeCollectionViewModel.needsRestart.accept(true)
//            self?.homeUpdateUserCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
//            self?.homeUpdateUserCoordinator = nil
//        }).disposed(by: disposeBag)
//    }
//
//    private func setupBindablesFromSettings() {
//        homeSettingsCoordinator?.requestedCancel.asObservable().subscribe(onNext: { [weak self] (_) in
//            self?.homeSettingsCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
//            self?.homeSettingsCoordinator = nil
//        }).disposed(by: disposeBag)
//
//        homeSettingsCoordinator?.didSetUser.subscribe(onNext: { [weak self] (user) in
//            self?.viewModel.forceFetchingAll = true
//            self?.viewModel.homeCollectionViewModel.needsRestart.accept(true)
//            self?.homeSettingsCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
//            self?.homeSettingsCoordinator = nil
//        }).disposed(by: disposeBag)
//
//        homeSettingsCoordinator?.requestedLogout.bind(to: requestedLogout).disposed(by: disposeBag)
//    }
//
//}
