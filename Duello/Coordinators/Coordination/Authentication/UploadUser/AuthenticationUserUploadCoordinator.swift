//
//  AuthenticationUserUploadCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class AuthenticationUserUploadCoordinator: UpdateUserCoordinatorType {
    
    //MARK: - ViewModels
    private lazy var viewModel: UploadUserViewModel = {
        let viewModel = UploadUserViewModel()
        viewModel.coordinator = self
        return viewModel
    }()
    
    //MARK: - Bindables
    var canceledUserUpload = PublishRelay<Void>()
    var didSetUser = PublishRelay<UserModel?>()
    
    //MARK: - Setup
    init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Methods
    func start() {
        let uploadUserController = AuthenticationUploadUserController(viewModel: viewModel)
        presentedController = UINavigationController(rootViewController: uploadUserController)
        rootController.present(presentedController!, animated: true, completion: nil)
    }
    
}

