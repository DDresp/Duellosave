//
//  UploadLocalSingleImagePostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

class UploadLocalSingleImagePostViewModel: UploadPostViewModel<LocalSingleImagePost>, UploadSingleImagePostDisplayer {
    
    //MARK: - Variables
    var type: FineMediaType = .localSingleImage
    var image: UIImage?
    var imageUrl: URL?
    
    //MARK: - Setup
    init(rawPost: RawSingleImagePost) {
        self.image = rawPost.singleImage
        super.init()
    }
    
    //MARK: - Methods
    private func makePost(imageUrl: String) -> LocalSingleImagePost {
        post = LocalSingleImagePost()
        post?.imageUrl.value = imageUrl
        return post ?? LocalSingleImagePost()
    }
    
    //MARK: - Networking
    override func saveData() {
        super.saveData()
        if !dataIsValid() { return }
        
        guard let image = image else { return }
        isLoading.accept(true)
        
        StoringService.shared.storeSingleImage(image: image).flatMapLatest { [weak self] (imageUrl) -> Observable<PostModel?> in
            let post = self?.makePost(imageUrl: imageUrl) ?? LocalSingleImagePost()
            return UploadingService.shared.create(post: post)
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
