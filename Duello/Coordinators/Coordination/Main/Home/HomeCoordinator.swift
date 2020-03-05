//
//  HomeCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class HomeCoordinator: HomeCoordinatorType {
    
    //MARK: - ChildCoordinators
    var homeUpdateUserCoordinator: HomeUpdateUserCoordinator?
    
    //MARK: - ViewModels
    lazy var viewModel: HomeViewModel = {
        let homeViewModel = HomeViewModel()
        homeViewModel.coordinator = self
        return homeViewModel
    }()
    
    //MARK: - Bindables
    var loggedOut = PublishSubject<Void>()
    var requestedSettings = PublishSubject<Void>()
    
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
        requestedSettings.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.goToUpdateUser()
        }).disposed(by: disposeBag)
    }
    
}

//MARK: - Extension: UpdateUser
extension HomeCoordinator {
    
    //GoTo
    private func goToUpdateUser() {
        guard let rootController = presentedController else { return }
        guard let user = viewModel.userHeaderDisplayer?.user.value else { return }
        homeUpdateUserCoordinator = HomeUpdateUserCoordinator(rootController: rootController, user: user)
        homeUpdateUserCoordinator?.start()
        setupUpdateUserBindables()
        
    }
    
    //Reactive
    private func setupUpdateUserBindables() {
        homeUpdateUserCoordinator?.canceledUserUpload.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.homeUpdateUserCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
            self?.homeUpdateUserCoordinator = nil
            
        }).disposed(by: disposeBag)
        
        homeUpdateUserCoordinator?.didSetUser.asObservable().subscribe(onNext: { [weak self] (user) in
            self?.viewModel.restart.accept(())
            self?.homeUpdateUserCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
            self?.homeUpdateUserCoordinator = nil
        }).disposed(by: disposeBag)
    }
    
}
