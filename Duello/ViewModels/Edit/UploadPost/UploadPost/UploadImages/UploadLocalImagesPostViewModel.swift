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
    var type: FineMediaEnum = .localImages
    let images: [UIImage]
    
    //MARK: - Setup
    init(rawPost: RawImagesPost, category: CategoryModel) {
        self.images = rawPost.images
        self.imagesSliderDisplayer = ImagesSliderViewModel()
        self.imagesSliderDisplayer.images.accept(images)
        super.init(category: category)
    }
    
    //MARK: - Methods
    private func makePost(imageUrls: [String]) {
        
        post = LocalImagesPost()
        
        for imageUrl in imageUrls {
            guard let urls = post?.getImageUrls() else { return }
            var urlStrings = urls.compactMap({ (url) -> String? in
                return url.absoluteString
            })
            urlStrings.append(imageUrl)
            post?.setImageUrls(urlStrings)
        }
        
    }
    
    //MARK: - Networking
    override func saveData() {
        super.saveData()
        if !dataIsValid() { return }
        
        isLoading.accept(true)
        
        StoringService.shared.storeImages(images: images).flatMapLatest { [weak self] (imageUrls) -> Observable<PostModel?> in
            self?.makePost(imageUrls: imageUrls)
            return UploadingService.shared.create(post: self?.post ?? LocalImagesPost())
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
