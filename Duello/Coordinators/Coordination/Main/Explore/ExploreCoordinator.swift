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
    
    //MARK: - ChildCoordinators
    var exploreCategoryProfileCoordinator: ExploreCategoryProfileCoordinator?
    
    //MARK: - ViewModels
    lazy var viewModel: ExploreViewModel = {
        let viewModel = ExploreViewModel()
        viewModel.coordinator = self
        return viewModel
    }()
    
    //MARK: - Bindables
    var requestedCategory: PublishSubject<CategoryModel?> = PublishSubject()
    
    //MARK: - Setup
    init() {
        let exploreController = ExploreController(viewModel: viewModel)
        presentedController = exploreController
        let navController = UINavigationController(rootViewController: presentedController)
        navController.tabBarItem.title = "Explore"
        navigationController = navController
        setupBindables()
    }
    
    //MARK: - Controllers
    var navigationController: UINavigationController?
    var presentedController: UIViewController!
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindables() {
        requestedCategory.subscribe(onNext: { [weak self] (category) in
            self?.goToCategoryProfile(with: category)
        }).disposed(by: disposeBag)
    }

}

//MARK: - Extension: CategoryProfile
extension ExploreCoordinator {
    
    //GoTo
    private func goToCategoryProfile(with category: CategoryModel?) {
        guard let rootController = navigationController, let category = category else { return }
        exploreCategoryProfileCoordinator = ExploreCategoryProfileCoordinator(rootController: rootController, category: category)
        exploreCategoryProfileCoordinator?.start()
        setupCategoryProfileBindables()
        
    }
    
    //Reactive
    private func setupCategoryProfileBindables() {
        
        exploreCategoryProfileCoordinator?.goBack.subscribe(onNext: { [weak self] (_) in
            guard let navigationController = self?.navigationController else { return }
            navigationController.popViewController(animated: true)
            self?.exploreCategoryProfileCoordinator = nil
        }).disposed(by: disposeBag)
        
    }
    
}

