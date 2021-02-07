//
//  UploadCategoryCoordinator.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import YPImagePicker

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
    var requestedImageUpload: PublishRelay<Void> = PublishRelay()
    
    //MARK: - Setup
    init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    //MARK: - Methods
    func start() {
        let categoryController = CategoryCreationUploadCategoryController(viewModel: viewModel)
        presentedController = UINavigationController(rootViewController: categoryController)
        rootController.present(presentedController!, animated: true, completion: nil)
        setupBindables()
    }
    
    //MARK: - Controllers
    var rootController: UIViewController
    var presentedController: UIViewController?
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindables() {
        disposeBag = DisposeBag()
        
        requestedImageUpload.subscribe(onNext: { [weak self] (_) in
            self?.goToImagePicker()
        }).disposed(by: disposeBag)
    }
    
}

//MARK: - Extension ImagePicker
extension UploadCategoryCoordinator {
    
    //GoTO
    private func goToImagePicker() {
        guard let presentedController = presentedController else { return }
        let imagePicker = getImagePicker()
        presentedController.present(imagePicker, animated: true)
        
    }
    
    //Setup
    private func getImagePicker() -> YPImagePicker {
        
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.library.onlySquare = true
        let imagePicker = YPImagePicker(configuration: config)
        
        imagePicker.didFinishPicking { [unowned imagePicker, weak self] (items, cancelled) in
            
            if cancelled {
                imagePicker.dismiss(animated: true)
                return
            }
            
            var image = UIImage()
            for item in items {
                switch item {
                case .photo(let photo):
                    image = photo.image
                default:
                    ()
                }
            }
            
            self?.viewModel.image.accept(image.withRenderingMode(.alwaysOriginal))
            imagePicker.dismiss(animated: true)
            
        }
        
        return imagePicker
    }
    
}
    


