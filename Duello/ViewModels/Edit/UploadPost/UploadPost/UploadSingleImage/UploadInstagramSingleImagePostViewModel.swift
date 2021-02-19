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
    var type: FineMediaEnum = .instagramSingleImage
    var image: UIImage?
    var imageUrl: URL?
    let apiLink: String
    
    //MARK: - Setup
    init(rawPost: RawInstagramSingleImagePost, category: CategoryModel) {
        self.imageUrl = rawPost.singleImageUrl
        self.apiLink = rawPost.apiLink
        super.init(category: category)
        self.mediaRatio = rawPost.mediaRatio
    }
    
    //MARK: - Methods
    private func makePost() {
        post = InstagramSingleImagePost()
        post?.apiUrl.value = apiLink
    }
    
    //MARK: - Networking
    override func saveData() {
        super.saveData()
        if !dataIsValid() { return }
        
        makePost()
        isLoading.accept(true)
        
        UploadingService.shared.create(post: self.post!).subscribe(onNext: { [weak self] (post) in
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
