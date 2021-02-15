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
    
    //MARK: - ChildCoordinators
    var postingCoordinator: ExploreCategoryPostingCoordinator?
    
    //MARK: - Models
    let category: CategoryModel
    
    //MARK: - ViewModels
    private lazy var viewModel: ExploreCategoryProfileViewModel = {
        let viewModel = ExploreCategoryProfileViewModel(category: category)
        viewModel.coordinator = self
        return viewModel
    }()
    
    //MARK: - Variables
    
    //MARK: - Bindables
    var requestedAddContent: PublishSubject<Void> = PublishSubject()
    var goBack: PublishSubject<Void> = PublishSubject()
    
    //MARK: - Setup
    init(rootController: UIViewController, category: CategoryModel) {
        self.rootController = rootController
        self.category = category
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Methods
    func start() {
        let viewController = ExploreCategoryProfileController(viewModel: viewModel)
        presentedController = viewController
        if let navigationController = rootController as? UINavigationController {
            navigationController.pushViewController(presentedController!, animated: true)
        }
        setupBindables()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindables() {
        
        requestedAddContent.subscribe(onNext: { [weak self] (_) in
            self?.goToPosting()
            }).disposed(by: disposeBag)
        
    }
    
}

//MARK: Extension: Posting
extension ExploreCategoryProfileCoordinator {
    
    private func goToPosting() {
        guard let rootController = presentedController else { return }
        postingCoordinator = ExploreCategoryPostingCoordinator(rootController: rootController, category: category)
        postingCoordinator?.start()
        setupPostingBindables()
    }
    
    private func setupPostingBindables() {
        
        postingCoordinator?.requestedCancel.subscribe(onNext: { [weak self] (_) in
            self?.postingCoordinator?.presentedController?.dismiss(animated: true)
            self?.postingCoordinator = nil
        }).disposed(by: disposeBag)
        
        postingCoordinator?.uploadedMedia.subscribe(onNext: { [weak self] (uploadedMedia) in
            
            if uploadedMedia, let postingController = self?.postingCoordinator?.presentedController {
                self?.viewModel.collectionViewModel.needsRestart.accept(true)
                postingController.dismiss(animated: true)
                self?.postingCoordinator = nil
            }

            }).disposed(by: disposeBag)
    }
    
}

