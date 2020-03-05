//
//  AuthenticationPhoneLoginCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class AuthenticationPhoneLoginCoordinator: AuthenticationPhoneLoginCoordinatorType {
    
    //MARK: - ViewModels
    lazy var viewModel: PhoneLoginViewModel = {
        let viewModel = PhoneLoginViewModel()
        viewModel.coordinator = self
        return viewModel
    }()
    
    //MARK: - Bindables
    var loggedIn = PublishRelay<Void>()
    var canceledPhoneLogin = PublishRelay<Void>()
    
    //MARK: - Setup
    init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Methods
    func start() {
        let phoneLoginController = AuthenticationPhoneLoginController(viewModel: viewModel)
        presentedController = UINavigationController(rootViewController: phoneLoginController)
        rootController.present(presentedController!, animated: true, completion: nil)
    }
    
}
