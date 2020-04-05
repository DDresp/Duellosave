//
//  CategoryProfileCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class ExploreCategoryProfileCoordinator: CategoryProfileCoordinatorType {
    
    //MARK: - ViewModels
    
    //MARK: - Variables
    
    //MARK: - Bindables
    
    //MARK: - Setup
    init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Methods
    func start() {
        let viewController = CategoryProfileController()
        presentedController = viewController
        if let navigationController = rootController as? UINavigationController {
            navigationController.pushViewController(presentedController!, animated: true)
        } else {
            rootController.present(presentedController!, animated: true)
        }
    }
    
}

