//
//  HomeUpdateUserCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class HomeUpdateUserCoordinator: UpdateUserCoordinatorType {
    
    //MARK: - Models
    var user: UserModel?
    
    //MARK: - ViewModels
    private var viewModel: UpdateUserViewModel?
    
    //MARK: - Bindables
    var canceledUserUpload = PublishRelay<Void>()
    var didSetUser = PublishRelay<UserModel?>()
    
    //MARK: - Setup
    init(rootController: UIViewController, user: UserModel?) {
        self.rootController = rootController
        self.user = user
        let viewModel = UpdateUserViewModel(user: user ?? User())
        viewModel.coordinator = self
        self.viewModel = viewModel
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Methods
    func start() {
        let homeUpdateUserController = HomeUpdateUserController(viewModel: viewModel ?? UpdateUserViewModel(user: User()))
        presentedController = UINavigationController(rootViewController: homeUpdateUserController)
        rootController.present(presentedController!, animated: true, completion: nil)
    }
    
}
