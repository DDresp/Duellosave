//
//  PostingUploadInstagramLinkCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class PostingUploadInstagramLinkCoordinator: UploadLinkCoordinatorType {
    
    //MARK: - ViewModels
    lazy var viewModel: UploadInstagramLinkDisplayer = {
        if forVideo {
            let viewModel = UploadInstagramVideoLinkViewModel()
            viewModel.coordinator = self
            return viewModel
            
        } else {
            let viewModel = UploadInstagramImagesLinkViewModel()
            viewModel.coordinator = self
            return viewModel
        }
    }()
    
    //MARK: - Variables
    let forVideo: Bool
    
    //MARK: - Bindables
    var canceledLinkUpload = PublishRelay<Void>()
    var data: PublishRelay<RawInstagramPostType> = PublishRelay()
    
    //MARK: - Setup
    init(rootController: UIViewController, forVideo: Bool) {
        self.rootController = rootController
        self.forVideo = forVideo
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Methods
    func start() {
        let postingUploadInstagramLinkController: UIViewController
        
        switch viewModel {
        case let viewModel as UploadInstagramImagesLinkViewModel:
            postingUploadInstagramLinkController = PostingUploadInstagramImagesLinkController(viewModel: viewModel)
        case let viewModel as UploadInstagramVideoLinkViewModel:
            postingUploadInstagramLinkController = PostingUploadInstagramVideoLinkController(viewModel: viewModel)
        default:
            postingUploadInstagramLinkController = UIViewController()
        }
        presentedController = UINavigationController(rootViewController: postingUploadInstagramLinkController)
        rootController.present(presentedController!, animated: true)
    }
    
}
