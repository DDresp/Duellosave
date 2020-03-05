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
    var type: MediaType = .instagramImages
    var images: [UIImage]?
    var imageUrls: [URL]?
    let apiLink: String
    
    //MARK: - Setup
    init(rawPost: RawInstagramImagesPost) {
        self.imageUrls = rawPost.imageUrls
        self.apiLink = rawPost.apiLink
        self.imagesSliderDisplayer = ImagesSliderViewModel()
        self.imagesSliderDisplayer.imageUrls.accept(imageUrls)
        super.init()
    }
    
    //MARK: - Methods
    private func makePost() -> InstagramImagesPost {
        post = InstagramImagesPost()
        post?.apiUrl.value = apiLink
        return post ?? InstagramImagesPost()
    }
    
    //MARK: - Networking
    override func saveData() {
        super.saveData()
        if !dataIsValid() { return }
        
        let post = makePost()
        isLoading.accept(true)
        
        UploadingService.shared.savePost(post: post).subscribe(onNext: { [weak self] (post) in
            self?.isLoading.accept(false)
            self?.coordinator?.didSavePost.accept(())
            
            }, onError: { [weak self] (error) in
                self?.isLoading.accept(false)
                if let uploadError = error as? UploadError {
                    self?.alert.accept(Alert(alertMessage: uploadError.errorMessage, alertHeader: uploadError.errorHeader))
                }
                print("developing error: ", error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
}
