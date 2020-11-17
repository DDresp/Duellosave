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
    
    //MARK: - Models
    var user: UserModel?
    
    //MARK: - ViewModels
    private var viewModel: UpdateUserViewModel?
    
    //MARK: - Bindables
    var closed = PublishRelay<Void>()
    var editedUser = PublishRelay<UserModel?>()
    
    //MARK: - Setup
    init(rootController: UIViewController, user: UserModel?) {
        self.rootController = rootController
        self.user = user
//        let viewModel = UpdateUserViewModel(user: user ?? User())
//        viewModel.coordinator = self
//        self.viewModel = viewModel
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Methods
    func start() {
        print("debug: start HomeSettingsCoordinator!")
//        let homeUpdateUserController = HomeUpdateUserController(viewModel: viewModel ?? UpdateUserViewModel(user: User()))
//        presentedController = UINavigationController(rootViewController: homeUpdateUserController)
//        rootController.present(presentedController!, animated: true, completion: nil)
    }
    
}

