//
//  ExploreCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 4/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class ExploreCoordinator: ExploreCoordinatorType {
    
    //MARK: - ViewModels
    lazy var viewModel: ExploreViewModel = {
        let viewModel = ExploreViewModel()
        viewModel.coordinator = self
        return viewModel
    }()
    
    //MARK: - Setup
    init() {
        let exploreController = ExploreController(viewModel: viewModel)
        presentedController = exploreController
        let navController = UINavigationController(rootViewController: presentedController)
        navController.tabBarItem.title = "Explore"
        navigationController = navController
    }
    
    //MARK: - Controllers
    var navigationController: UINavigationController?
    var presentedController: UIViewController!

}
