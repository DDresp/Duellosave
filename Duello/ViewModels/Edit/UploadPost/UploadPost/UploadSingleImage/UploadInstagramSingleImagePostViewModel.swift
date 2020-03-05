//
//  UploadInstagramSingleImagePostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

class UploadInstagramSingleImagePostViewModel: UploadPostViewModel<InstagramSingleImagePost>, UploadSingleImagePostDisplayer {
    
    //MARK: - Variables
    var type: MediaType = .instagramSingleImage
    var image: UIImage?
    var imageUrl: URL?
    let apiLink: String
    
    //MARK: - Setup
    init(rawPost: RawInstagramSingleImagePost) {
        self.imageUrl = rawPost.singleImageUrl
        self.apiLink = rawPost.apiLink
        super.init()
    }
    
    //MARK: - Methods
    private func makePost() -> InstagramSingleImagePost {
        post = InstagramSingleImagePost()
        post?.apiUrl.value = apiLink
        return post ?? InstagramSingleImagePost()
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
