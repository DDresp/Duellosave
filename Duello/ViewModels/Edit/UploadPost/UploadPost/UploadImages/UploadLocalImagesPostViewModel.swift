//
//  UploadLocalImagesPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

class UploadLocalImagesPostViewModel: UploadPostViewModel<LocalImagesPost>, UploadImagesPostDisplayer {
    
    //MARK: - ChildViewModels
    var imagesSliderDisplayer: ImagesSliderDisplayer
    
    //MARK: - Variables
    var type: FineMediaType = .localImages
    let images: [UIImage]
    
    //MARK: - Setup
    init(rawPost: RawImagesPost) {
        self.images = rawPost.images
        self.imagesSliderDisplayer = ImagesSliderViewModel()
        self.imagesSliderDisplayer.images.accept(images)
        super.init()
    }
    
    //MARK: - Methods
    private func makePost(imageUrls: [String]) -> LocalImagesPost {
        
        post = LocalImagesPost()
        guard let imagesModel = post?.imageUrls.model as? LocalImages else { return LocalImagesPost() }
        for (index, imageUrl) in imageUrls.enumerated() {
            switch index {
            case 0: imagesModel.imageUrl1.value = imageUrl
            case 1: imagesModel.imageUrl2.value = imageUrl
            case 2: imagesModel.imageUrl3.value = imageUrl
            case 3: imagesModel.imageUrl4.value = imageUrl
            case 4: imagesModel.imageUrl5.value = imageUrl
            case 5: imagesModel.imageUrl6.value = imageUrl
            default:
                ()
            }
        }
        return post ?? LocalImagesPost()
    }
    
    //MARK: - Networking
    override func saveData() {
        super.saveData()
        if !dataIsValid() { return }
        
        isLoading.accept(true)
        
        StoringService.shared.storeImages(images: images).flatMapLatest { [weak self] (imageUrls) -> Observable<PostModel?> in
            let post = self?.makePost(imageUrls: imageUrls)
            return UploadingService.shared.create(post: post ?? LocalImagesPost())
            }.subscribe(onNext: { [weak self] (post) in
                self?.isLoading.accept(false)
                self?.coordinator?.didSavePost.accept(())
                }, onError: { [weak self] (error) in
                    self?.isLoading.accept(false)
                    if let uploadError = error as? DuelloError {
                        self?.alert.accept(Alert(alertMessage: uploadError.errorMessage, alertHeader: uploadError.errorHeader))
                    }
                    print("error: ", error.localizedDescription)
            }).disposed(by: disposeBag)
    }

}
