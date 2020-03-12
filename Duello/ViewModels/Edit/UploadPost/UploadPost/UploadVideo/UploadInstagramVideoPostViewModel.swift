//
//  UploadInstagramVideoPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import AVFoundation

class UploadInstagramVideoPostViewModel: UploadPostViewModel<InstagramVideoPost>, UploadVideoPostDisplayer {
    
    //MARK: - Variables
    var type: MediaType = .instagramVideo
    let apiLink: String
    var loadedVideo: Bool = false //Developing
    
    //MARK: - Bindables
    let videoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let thumbnailUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let thumbnailImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    var tappedSoundIcon: PublishRelay<Void> = PublishRelay()
    var tappedVideo: PublishRelay<Void> = PublishRelay()
    var isMuted: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    //    var playVideo: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    //    var flipThumbnailImage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var playVideo: PublishRelay<Bool> = PublishRelay()
    //    var showThumbnailImage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var startVideo: PublishRelay<AVAsset> = PublishRelay()
    var playVideoRequested: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    //MARK: - Setup
    init(rawPost: RawInstagramVideoPost) {
        self.videoUrl.accept(rawPost.videoURL)
        self.thumbnailUrl.accept(rawPost.thumbnailUrl)
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
                if let uploadError = error as? UploadingError {
                    self?.alert.accept(Alert(alertMessage: uploadError.errorMessage, alertHeader: uploadError.errorHeader))
                }
                print("error: ", error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
}
