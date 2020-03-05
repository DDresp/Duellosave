//
//  PostingUploadPostCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class PostingUploadPostCoordinator: UploadPostCoordinatorType {
    
    //MARK: - ViewModels
    private lazy var viewModel: UploadPostDisplayer? = {
        
        let viewModel: UploadPostDisplayer?
        
        switch rawPost {
        case let post as RawSingleImagePost:
            let vm = UploadLocalSingleImagePostViewModel(rawPost: post)
            vm.coordinator = self
            viewModel = vm
        case let post as RawImagesPost:
            let vm = UploadLocalImagesPostViewModel(rawPost: post)
            vm.coordinator = self
            viewModel = vm
        case let post as RawVideoPost:
            let vm = UploadLocalVideoPostViewModel(rawPost: post)
            vm.coordinator = self
            viewModel = vm
        case let post as RawInstagramVideoPost:
            let vm = UploadInstagramVideoPostViewModel(rawPost: post)
            vm.coordinator = self
            viewModel = vm
        case let post as RawInstagramImagesPost:
            let vm = UploadInstagramImagesPostViewModel(rawPost: post)
            vm.coordinator = self
            viewModel = vm
        case let post as RawInstagramSingleImagePost:
            let vm = UploadInstagramSingleImagePostViewModel(rawPost: post)
            vm.coordinator = self
            viewModel = vm
        default:
            viewModel = nil
        }
        return viewModel
    }()
    
    //MARK: - Variables
    let rawPost: RawPostType
    
    //MARK: - Bindables
    var didSavePost: PublishRelay<Void> = PublishRelay<Void>()
    
    //MARK: - Setup
    init(rootController: UIViewController, rawPost: RawPostType) {
        self.rootController = rootController
        self.rawPost = rawPost
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Methods
    func start() {
        let uploadPostController: UIViewController

        switch viewModel {
        case let viewModel as UploadLocalSingleImagePostViewModel:
            uploadPostController = PostingUploadLocalSingleImagePostController(viewModel: viewModel)
        case let viewModel as UploadInstagramSingleImagePostViewModel:
            uploadPostController = PostingUploadInstagramSingleImagePostController(viewModel: viewModel)
        case let viewModel as UploadLocalImagesPostViewModel:
            uploadPostController = PostingUploadLocalImagesPostController(viewModel: viewModel)
        case let viewModel as UploadInstagramImagesPostViewModel:
            uploadPostController = PostingUploadInstagramImagesPostController(viewModel: viewModel)
        case let viewModel as UploadLocalVideoPostViewModel:
            uploadPostController = PostingUploadLocalVideoPostController(viewModel: viewModel)
        case let viewModel as UploadInstagramVideoPostViewModel:
            uploadPostController = PostingUploadInstagramVideoPostController(viewModel: viewModel)
        default:
            uploadPostController = ViewController()
        }
        presentedController = uploadPostController
        if let navigationController = rootController as? UINavigationController {
            navigationController.pushViewController(presentedController!, animated: true)
        } else {
            rootController.present(presentedController!, animated: true)
        }
    }
    
}
