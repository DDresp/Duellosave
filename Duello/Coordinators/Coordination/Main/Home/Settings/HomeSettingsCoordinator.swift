//
//  HomeSettingsCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 11/17/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class HomeSettingsCoordinator: SettingsCoordinatorType {
    
    //MARK: - ChildCoordinators
    var homeEditUserCoordinator: HomeUpdateUserCoordinator?
    
    //MARK: - Models
    var user: UserModel?
    
    //MARK: - ViewModels
    lazy var viewModel: HomeSettingsViewModel = {
        let viewModel = HomeSettingsViewModel()
        viewModel.coordinator = self
        return viewModel
    }()
    
    //MARK: - Bindables
    var requestedCancel = PublishRelay<Void>()
    var requestedLogout = PublishRelay<Void>()
    var requestedEdit = PublishRelay<Void>()
    
    var didSetUser = PublishRelay<UserModel?>()
    
    //MARK: - Setup
    init(rootController: UIViewController, user: UserModel?) {
        self.rootController = rootController
        self.user = user
        setupBindables()
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Methods
    func start() {
        let homeSettingsController = HomeSettingsController(viewModel: viewModel)
        presentedController = UINavigationController(rootViewController: homeSettingsController)
        rootController.present(presentedController!, animated: true, completion: nil)
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindables() {
        requestedEdit.subscribe(onNext: { [weak self] (_) in
            self?.goToEdit()
        }).disposed(by: disposeBag)
    }
    
}

//MARK: - Extension: EditUser
extension HomeSettingsCoordinator {
    
    //GoTo
    private func goToEdit() {
        guard let rootController = presentedController else { return }
        homeEditUserCoordinator = HomeUpdateUserCoordinator(rootController: rootController, user: user)
        homeEditUserCoordinator?.start()
        setupBindablesFromEditUser()
    }
    
    private func setupBindablesFromEditUser() {
        homeEditUserCoordinator?.canceledUserUpload.subscribe(onNext: { [weak self] (_) in
//            self?.homeEditUserCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
            (self?.presentedController as! UINavigationController).popViewController(animated: true)
            self?.homeEditUserCoordinator = nil
            
        }).disposed(by: disposeBag)
        
        homeEditUserCoordinator?.didSetUser.bind(to: didSetUser).disposed(by: disposeBag)
        
    }
    
}

