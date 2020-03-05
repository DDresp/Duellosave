//
//  UploadInstagramVideoPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadInstagramVideoPostViewModel: UploadPostViewModel<InstagramVideoPost>, UploadVideoPostDisplayer {
    
    //MARK: - Variables
    var type: MediaType = .instagramVideo
    let apiLink: String
    
    //MARK: - Bindables
    let localVideoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let remoteThumbnailUrlString: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let localThumbnailImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    var tappedSoundIcon: PublishRelay<Void> = PublishRelay()
    var tappedVideo: PublishRelay<Void> = PublishRelay()
    var isMuted: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var shouldPlayVideo: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var showThumbnailImage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: - Setup
    init(rawPost: RawInstagramVideoPost) {
        self.localVideoUrl.accept(rawPost.videoURL)
        self.localThumbnailImage.accept(rawPost.thumbnailImage)
        self.apiLink = rawPost.apiLink
        super.init()
        setupBasicBindables()
    }
    
    //MARK: - Methods
    private func makePost() -> InstagramVideoPost {
        post = InstagramVideoPost()
        post?.apiUrl.value = apiLink
        return post ?? InstagramVideoPost()
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
