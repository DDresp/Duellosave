//
//  PostingCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift
import YPImagePicker

class ExploreCategoryPostingCoordinator: PostingCoordinatorType {
    
    //MARK: - ChildCoordinators
    var postingUploadPostCoordinator: ExploreCategoryPostingUploadPostCoordinator?
    var postingUploadInstagramLinkCoordinator: ExploreCategoryPostingUploadInstagramLinkCoordinator?
    
    //MARK: - Models
    let category: CategoryModel
    
    //MARK: - ViewModels
    lazy var viewModel: ExploreCategoryPostingViewModel = {
        let postingViewModel = ExploreCategoryPostingViewModel(category: category)
        postingViewModel.coordinator = self
        return postingViewModel
    }()
    
    //MARK: - Bindables
    var requestedVideoUpload = PublishSubject<Void>()
    var requestedImageUpload = PublishSubject<Void>()
    var requestedInstagramVideoUpload = PublishSubject<Void>()
    var requestedInstagramImageUpload = PublishSubject<Void>()
    var uploadedMedia: BehaviorRelay = BehaviorRelay(value: false)

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
        let postingController = ExploreCategoryPostingController(viewModel: viewModel)
        presentedController = postingController
        
        if let navigationController = rootController as? UINavigationController {
            navigationController.pushViewController(presentedController!, animated: true)
        } else {
            rootController.present(presentedController!, animated: true)
        }
        setupBindables()
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindables() {
        disposeBag = DisposeBag()
        
        requestedVideoUpload.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.gotToVideoPicker()
        }).disposed(by: disposeBag)
        
        requestedImageUpload.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.goToImagePicker()
        }).disposed(by: disposeBag)
        
        requestedInstagramVideoUpload.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.goToUploadInstagramLink(forVideo: true)
        }).disposed(by: disposeBag)
        
        requestedInstagramImageUpload.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.goToUploadInstagramLink(forVideo: false)
        }).disposed(by: disposeBag)

    }
    
}

//MARK: - Extension: ImagePicker
extension ExploreCategoryPostingCoordinator {
    
    //GoTo
    private func goToImagePicker() {
        let imagePicker = setupImagePicker()
        configureImagePicker(imagePicker: imagePicker)
        imagePicker.modalPresentationStyle = .fullScreen
        rootController.present(imagePicker, animated: true)
    }
    
    //Setup
    private func setupImagePicker() -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 6
        config.screens = [.library]
        config.showsPhotoFilters = false
        config.isScrollToChangeModesEnabled = false
        config.library.onlySquare = true
        config.colors.tintColor = NAVBARBUTTONCOLOR
        return YPImagePicker(configuration: config)
    }
    
    //Callback (similar to Reactive)
    private func configureImagePicker(imagePicker: YPImagePicker) {
        
        imagePicker.didFinishPicking { [unowned imagePicker, weak self] (items, cancelled) in
            var images = [UIImage]()
            for item in items {
                switch item {
                case .photo(let photo):
                    images.append(photo.image)
                default:
                    ()
                }
            }
            if cancelled {
                self?.postingUploadPostCoordinator = nil
                imagePicker.dismiss(animated: true)
                return
            }
            if images.count == 1, let singleImage = images.first {
                self?.goToUploadPost(from: imagePicker, rawPost: RawSingleImagePost(singleImage: singleImage))
            } else if images.count > 1 {
                self?.goToUploadPost(from: imagePicker, rawPost: RawImagesPost(images: images))
            } else {
                imagePicker.dismiss(animated: true)
            }
        }
    }
    
}

//MARK: - Extension: VideoPicker
extension ExploreCategoryPostingCoordinator {
    
    //GoTo
    private func gotToVideoPicker() {
        let videoPicker = setupVideoPicker()
        configureVideoPicker(videoPicker: videoPicker)
        videoPicker.modalPresentationStyle = .fullScreen
        rootController.present(videoPicker, animated: true)
    }
    
    //Setup
    private func setupVideoPicker() -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.library.mediaType = .video
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 1
        config.showsPhotoFilters = false
        config.isScrollToChangeModesEnabled = false
        config.library.onlySquare = true
        config.colors.tintColor = NAVBARBUTTONCOLOR
        return YPImagePicker(configuration: config)
    }
    
    //Callback (similar to Reactive)
    private func configureVideoPicker(videoPicker: YPImagePicker) {
        
        videoPicker.didFinishPicking { [unowned videoPicker, weak self] (items, cancelled) in
            
            if cancelled {
                self?.postingUploadPostCoordinator = nil
                videoPicker.dismiss(animated: true)
                return
            }
            
            if let video = items.singleVideo {
                self?.goToUploadPost(from: videoPicker, rawPost: RawVideoPost(videoUrl: video.url, thumbnailImage: video.thumbnail))
            } else {
                videoPicker.dismiss(animated: true)
            }
            
        }
    }
    
}

//MARK: - Extension: UploadInstagramLink
extension ExploreCategoryPostingCoordinator {
    
    //GoTo
    private func goToUploadInstagramLink(forVideo: Bool) {
        guard let rootController = presentedController else { return }
        postingUploadInstagramLinkCoordinator = ExploreCategoryPostingUploadInstagramLinkCoordinator(rootController: rootController, forVideo: forVideo)
        postingUploadInstagramLinkCoordinator?.start()
        setupUploadInstagramLinkBindables()
    }
    
    //Reactive
    private func setupUploadInstagramLinkBindables() {
        guard let instagramCoordinator = postingUploadInstagramLinkCoordinator else { return }
        
        instagramCoordinator.canceledLinkUpload.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.postingUploadInstagramLinkCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
            self?.postingUploadInstagramLinkCoordinator = nil
        }).disposed(by: disposeBag)
        
        instagramCoordinator.data.subscribe(onNext: { [weak self] (rawPost) in
            guard let vc = instagramCoordinator.presentedController else { return }
            self?.goToUploadPost(from: vc, rawPost: rawPost)
        }).disposed(by: disposeBag)
    }
    
}

//MARK: - Extension: UploadPost
extension ExploreCategoryPostingCoordinator {
    
    //GoTo
    private func goToUploadPost(from rootController: UIViewController, rawPost: RawPostType) {
        postingUploadPostCoordinator = ExploreCategoryPostingUploadPostCoordinator(rootController: rootController, rawPost: rawPost, category: category)
        postingUploadPostCoordinator?.start()
        setupUploadPostBindables()
    }
    
    //Reactive
    private func setupUploadPostBindables() {
        postingUploadPostCoordinator?.didSavePost.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.postingUploadPostCoordinator?.rootController.dismiss(animated: true, completion: {
                self?.postingUploadPostCoordinator = nil
                self?.uploadedMedia.accept(true)
            })
            
        }).disposed(by: disposeBag)
    }
    
}


//import RxCocoa
//import RxSwift
//import YPImagePicker
//
//class PostingCoordinator: PostingCoordinatorType {
//
//    //MARK: - ChildCoordinators
//    var postingUploadPostCoordinator: PostingUploadPostCoordinator?
//    var postingUploadInstagramLinkCoordinator: PostingUploadInstagramLinkCoordinator?
//
//    //MARK: - ViewModels
//    lazy var viewModel: PostingViewModel = {
//        let postingViewModel = PostingViewModel()
//        postingViewModel.coordinator = self
//        return postingViewModel
//    }()
//
//    //MARK: - Bindables
//    var requestedVideoUpload = PublishSubject<Void>()
//    var requestedImageUpload = PublishSubject<Void>()
//    var requestedInstagramVideoUpload = PublishSubject<Void>()
//    var requestedInstagramImageUpload = PublishSubject<Void>()
//
//    //MARK: - Setup
//    init() {
//        let postingController = PostingController(viewModel: viewModel)
//        presentedController = postingController
//        let navController = UINavigationController(rootViewController: presentedController)
//        navController.tabBarItem.title = "Post"
//        navigationController = navController
//        setupBindables()
//    }
//
//    //MARK: - Controllers
//    var navigationController: UINavigationController?
//    var presentedController: UIViewController!
//
//    //MARK: - Reactive
//    private let disposeBag = DisposeBag()
//
//    private func setupBindables() {
//
//        requestedVideoUpload.asObservable().subscribe(onNext: { [weak self] (_) in
//            self?.gotToVideoPicker()
//        }).disposed(by: disposeBag)
//
//        requestedImageUpload.asObservable().subscribe(onNext: { [weak self] (_) in
//            self?.goToImagePicker()
//        }).disposed(by: disposeBag)
//
//        requestedInstagramVideoUpload.asObservable().subscribe(onNext: { [weak self] (_) in
//            self?.goToUploadInstagramLink(forVideo: true)
//        }).disposed(by: disposeBag)
//
//        requestedInstagramImageUpload.asObservable().subscribe(onNext: { [weak self] (_) in
//            self?.goToUploadInstagramLink(forVideo: false)
//        }).disposed(by: disposeBag)
//
//    }
//
//}
//
////MARK: - Extension: ImagePicker
//extension PostingCoordinator {
//
//    //GoTo
//    private func goToImagePicker() {
//        let imagePicker = setupImagePicker()
//        configureImagePicker(imagePicker: imagePicker)
//        imagePicker.modalPresentationStyle = .fullScreen
//        navigationController?.present(imagePicker, animated: true)
//    }
//
//    //Setup
//    private func setupImagePicker() -> YPImagePicker {
//        var config = YPImagePickerConfiguration()
//        config.hidesStatusBar = false
//        config.library.maxNumberOfItems = 6
//        config.screens = [.library]
//        config.showsPhotoFilters = false
//        config.isScrollToChangeModesEnabled = false
//        config.library.onlySquare = true
//        config.colors.tintColor = NAVBARCOLOR
//        return YPImagePicker(configuration: config)
//    }
//
//    //Callback (similar to Reactive)
//    private func configureImagePicker(imagePicker: YPImagePicker) {
//
//        imagePicker.didFinishPicking { [unowned imagePicker, weak self] (items, cancelled) in
//            var images = [UIImage]()
//            for item in items {
//                switch item {
//                case .photo(let photo):
//                    images.append(photo.image)
//                default:
//                    ()
//                }
//            }
//            if cancelled {
//                self?.postingUploadPostCoordinator = nil
//                imagePicker.dismiss(animated: true)
//                return
//            }
//            if images.count == 1, let singleImage = images.first {
//                self?.goToUploadPost(from: imagePicker, rawPost: RawSingleImagePost(singleImage: singleImage))
//            } else if images.count > 1 {
//                self?.goToUploadPost(from: imagePicker, rawPost: RawImagesPost(images: images))
//            } else {
//                imagePicker.dismiss(animated: true)
//            }
//        }
//    }
//
//}
//
////MARK: - Extension: VideoPicker
//extension PostingCoordinator {
//
//    //GoTo
//    private func gotToVideoPicker() {
//        let videoPicker = setupVideoPicker()
//        configureVideoPicker(videoPicker: videoPicker)
//        videoPicker.modalPresentationStyle = .fullScreen
//        navigationController?.present(videoPicker, animated: true)
//    }
//
//    //Setup
//    private func setupVideoPicker() -> YPImagePicker {
//        var config = YPImagePickerConfiguration()
//        config.screens = [.library]
//        config.library.mediaType = .video
//        config.hidesStatusBar = false
//        config.library.maxNumberOfItems = 1
//        config.showsPhotoFilters = false
//        config.isScrollToChangeModesEnabled = false
//        config.library.onlySquare = true
//        config.colors.tintColor = NAVBARCOLOR
//        return YPImagePicker(configuration: config)
//    }
//
//    //Callback (similar to Reactive)
//    private func configureVideoPicker(videoPicker: YPImagePicker) {
//
//        videoPicker.didFinishPicking { [unowned videoPicker, weak self] (items, cancelled) in
//
//            if cancelled {
//                self?.postingUploadPostCoordinator = nil
//                videoPicker.dismiss(animated: true)
//                return
//            }
//
//            if let video = items.singleVideo {
//                self?.goToUploadPost(from: videoPicker, rawPost: RawVideoPost(videoUrl: video.url, thumbnailImage: video.thumbnail))
//            } else {
//                videoPicker.dismiss(animated: true)
//            }
//
//        }
//    }
//
//}
//
////MARK: - Extension: UploadInstagramLink
//extension PostingCoordinator {
//
//    //GoTo
//    private func goToUploadInstagramLink(forVideo: Bool) {
//        guard let rootController = presentedController else { return }
//        postingUploadInstagramLinkCoordinator = PostingUploadInstagramLinkCoordinator(rootController: rootController, forVideo: forVideo)
//        postingUploadInstagramLinkCoordinator?.start()
//        setupUploadInstagramLinkBindables()
//    }
//
//    //Reactive
//    private func setupUploadInstagramLinkBindables() {
//        guard let instagramCoordinator = postingUploadInstagramLinkCoordinator else { return }
//
//        instagramCoordinator.canceledLinkUpload.asObservable().subscribe(onNext: { [weak self] (_) in
//            self?.postingUploadInstagramLinkCoordinator?.presentedController?.dismiss(animated: true, completion: nil)
//            self?.postingUploadInstagramLinkCoordinator = nil
//        }).disposed(by: disposeBag)
//
//        instagramCoordinator.data.subscribe(onNext: { [weak self] (rawPost) in
//            guard let vc = instagramCoordinator.presentedController else { return }
//            self?.goToUploadPost(from: vc, rawPost: rawPost)
//        }).disposed(by: disposeBag)
//    }
//
//}
//
////MARK: - Extension: UploadPost
//extension PostingCoordinator {
//
//    //GoTo
//    private func goToUploadPost(from rootController: UIViewController, rawPost: RawPostType) {
//        postingUploadPostCoordinator = PostingUploadPostCoordinator(rootController: rootController, rawPost: rawPost)
//        postingUploadPostCoordinator?.start()
//        setupUploadPostBindables()
//    }
//
//    //Reactive
//    private func setupUploadPostBindables() {
//        postingUploadPostCoordinator?.didSavePost.asObservable().subscribe(onNext: { [weak self] (_) in
//            self?.postingUploadPostCoordinator?.rootController.dismiss(animated: true, completion: {
//                self?.postingUploadPostCoordinator = nil
//            })
//
//        }).disposed(by: disposeBag)
//    }
//
//}
