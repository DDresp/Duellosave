//
//  MainCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class MainCoordinator: MainCoordinatorType {
    
    //MARK: - ChildCoordinators
    private var homeCoordinator = HomeCoordinator()
    private var exploreCoordinator = ExploreCoordinator()
    
    //MARK: - ViewModels
    lazy var viewModel: MainViewModel = {
        let viewModel = MainViewModel()
        viewModel.coordinator = self
        return viewModel
    }()
    
    //MARK: - Bindables
    var loggedOut = PublishSubject<Void>()
    
    //MARK: - Setup
    init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    private func setupChildViewControllers(for tabBarController: UITabBarController) {
        tabBarController.viewControllers = [
            exploreCoordinator.navigationController ?? UIViewController(),
            homeCoordinator.navigationController ?? UIViewController(),
        ]
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Methods
    func start() {
        let mainController = MainController(viewModel: viewModel)
        setupChildViewControllers(for: mainController)
        presentedController = mainController
        rootController.present(presentedController!, animated: true)
        setupBindables()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupHomeBindables()
    }
    
}

//MARK: - Extension: Home
extension MainCoordinator {
    
    //Reactive
    private func setupHomeBindables() {
        homeCoordinator.requestedLogout.bind(to: loggedOut).disposed(by: disposeBag)

    }
    
}
