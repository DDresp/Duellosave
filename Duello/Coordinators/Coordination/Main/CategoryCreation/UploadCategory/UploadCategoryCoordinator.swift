//
//  UploadCategoryCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadCategoryCoordinator: UploadCategoryCoordinatorType {
    
    //MARK: - ViewModels
    private lazy var viewModel: UploadCategoryViewModel = {
        let viewModel = UploadCategoryViewModel()
        viewModel.coordinator = self
        return viewModel
    }()
    
    //MARK: - Bindables
    var didSaveCategory: PublishRelay<Void> = PublishRelay()
    var canceled: PublishRelay<Void> = PublishRelay()
    
    //MARK: - Setup
    init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    //MARK: - Methods
    func start() {
        let uploadCategoryController = UploadCategoryController(viewModel: viewModel)
        presentedController = UINavigationController(rootViewController: uploadCategoryController)
        rootController.present(presentedController!, animated: true, completion: nil)
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?

}
