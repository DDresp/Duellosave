//
//  UploadLocalVideoPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadLocalVideoPostViewModel: UploadPostViewModel<LocalVideoPost>, UploadVideoPostDisplayer {
    
    //MARK: - Variables
    var type: MediaType = .localVideo
    
    //MARK: - Bindables
    let localVideoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let localThumbnailImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    let remoteThumbnailUrlString: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var tappedVideo: PublishRelay<Void> = PublishRelay()
    var tappedSoundIcon: PublishRelay<Void> = PublishRelay()
    var isMuted: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var showThumbnailImage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var shouldPlayVideo: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    //MARK: - Setup
    init(rawPost: RawVideoPost) {
        self.localVideoUrl.accept(rawPost.videoUrl)
        self.localThumbnailImage.accept(rawPost.thumbnailImage)
        super.init()
        setupBasicBindables()
    }
    
    //MARK: - Methods
    private func makePost(thumbnailUrl: String, videoUrl: String) -> LocalVideoPost {
        post = LocalVideoPost()
        post?.thumbNailUrl.value = thumbnailUrl
        post?.videoUrl.value = videoUrl
        return post ?? LocalVideoPost()
    }
    
    //MARK: - Networking
    override func saveData() {
        super.saveData()
        if !dataIsValid() { return }
        
        guard let videoUrl = localVideoUrl.value else { return }
        guard let image = localThumbnailImage.value else { return }
        isLoading.accept(true)
        
        StoringService.shared.storeVideoAndThumbnail(image: image, videoUrl: videoUrl).flatMapLatest { [weak self] (urlStrings) -> Observable<PostModel?> in
            let post = self?.makePost(thumbnailUrl: urlStrings[0], videoUrl: urlStrings[1]) ?? LocalVideoPost()
            return UploadingService.shared.savePost(post: post)
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
