//
//  UploadInstagramImagesPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

class UploadInstagramImagesPostViewModel: UploadPostViewModel<InstagramImagesPost>, UploadImagesPostDisplayer {
    
    //MARK: - Child ViewModels
    var imagesSliderDisplayer: ImagesSliderDisplayer
    
    //MARK: - Variables
    var type: FineMediaEnum = .instagramImages
    var images: [UIImage]?
    var imageUrls: [URL]?
    let apiLink: String
    
    //MARK: - Setup
    init(rawPost: RawInstagramImagesPost, category: CategoryModel) {
        self.imageUrls = rawPost.imageUrls
        self.apiLink = rawPost.apiLink
        self.imagesSliderDisplayer = ImagesSliderViewModel()
        self.imagesSliderDisplayer.imageUrls.accept(imageUrls)
        super.init(category: category)
        self.mediaRatio = rawPost.mediaRatio
        
    }
    
    //MARK: - Methods
    private func makePost() {
        post = InstagramImagesPost()
        post?.setApiUrl(apiLink)
    }
    
    //MARK: - Networking
    override func saveData() {
        super.saveData()
        if !dataIsValid() { return }
        
        makePost()
        isLoading.accept(true)
        
        UploadingService.shared.create(post: post!).subscribe(onNext: { [weak self] (post) in
            self?.isLoading.accept(false)
            self?.coordinator?.didSavePost.accept(())
            
            }, onError: { [weak self] (error) in
                self?.isLoading.accept(false)
                if let uploadError = error as? UploadingError {
                    self?.alert.accept(Alert(alertMessage: uploadError.errorMessage, alertHeader: uploadError.errorHeader))
                }
                print("error: ", error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
}
