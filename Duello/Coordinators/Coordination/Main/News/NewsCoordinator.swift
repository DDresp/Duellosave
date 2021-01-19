//
//  NewsCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/17/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class NewsCoordinator: HomeCoordinatorType {
    
    //Temporary
    var requestedLogout: PublishSubject<Void> = PublishSubject()
    var requestedSettings: PublishSubject<UserModel> = PublishSubject()
    var requestedEditing: PublishSubject<UserModel> = PublishSubject()

    //MARK: - ViewModels
    lazy var viewModel: HomeViewModel = {
        let homeViewModel = HomeViewModel()
        homeViewModel.coordinator = self
        return homeViewModel
    }()
    
    //MARK: - Setup
    init() {
        let newsController = NewsController(viewModel: viewModel)
        newsController.view.backgroundColor = .orange
        presentedController = newsController
        let navController = UINavigationController(rootViewController: presentedController)
        navController.tabBarItem.title = "News"
        navigationController = navController
    }
    
    //MARK: - Controllers
    var navigationController: UINavigationController?
    var presentedController: UIViewController!
    
    
}
