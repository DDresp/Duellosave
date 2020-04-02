//
//  CategoryCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryCreationCoordinator: CategoryCreationCoordinatorType {
    
    //MARK: - ChildCoordinators
    var uploadCategoryCoordinator: UploadCategoryCoordinatorType?
    
    //MARK: - ViewModels
    lazy var viewModel: CategoryCreationViewModel = {
        let viewModel = CategoryCreationViewModel()
        viewModel.coordinator = self
        return viewModel
    }()
    
    //MARK: - Bindables
    var requestedCategoryUpload: PublishSubject<Void> = PublishSubject()
    
    //MARK: - Setup
    init() {
        let categoryController = CategoryCreationController(viewModel: viewModel)
        presentedController = categoryController
        let navController = UINavigationController(rootViewController: presentedController)
        navController.tabBarItem.title = "Category"
        navigationController = navController
        setupBindables()
    }
    
    //MARK: - Controllers
    var presentedController: UIViewController!
    var navigationController: UINavigationController?
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindables() {
        requestedCategoryUpload.subscribe(onNext: { [weak self] (_) in
            self?.goToUploadCategory()
        }).disposed(by: disposeBag)
    }
    
}   

//MARK: - Extension: UploadCategory
extension CategoryCreationCoordinator {
    
    //GoTo
    private func goToUploadCategory() {
        uploadCategoryCoordinator = UploadCategoryCoordinator(rootController: presentedController)
        uploadCategoryCoordinator?.start()
        setupUploadCategoryBindables()
    }
    
    private func setupUploadCategoryBindables() {
        
        guard let coordinator = uploadCategoryCoordinator else { return }
        Observable.of(coordinator.canceled, coordinator.didSaveCategory).merge().subscribe(onNext: { [weak self] (_) in
            self?.uploadCategoryCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
            self?.uploadCategoryCoordinator = nil
        }).disposed(by: disposeBag)
        
    }
    
}
