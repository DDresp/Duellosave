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
    var type: FineMediaEnum = .instagramVideo
    let apiLink: String
    
    //MARK: - Bindables
    let videoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let videoAsset: BehaviorRelay<AVAsset?> = BehaviorRelay(value: nil)
    let thumbnailUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let thumbnailImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
    let playVideoRequested: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let startVideo: PublishRelay<AVAsset> = PublishRelay()
    let isMuted: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    let tappedVideo: PublishRelay<Void> = PublishRelay()
    let tappedSoundIcon: PublishRelay<Void> = PublishRelay()


    //MARK: - Setup
    init(rawPost: RawInstagramVideoPost, category: CategoryModel) {
        self.videoUrl.accept(rawPost.videoURL)
        self.thumbnailUrl.accept(rawPost.thumbnailUrl)
        self.apiLink = rawPost.apiLink
        super.init(category: category)
        self.mediaRatio = rawPost.mediaRatio
        setupVideoPlayerBindables()
    }
    
    //MARK: - Methods
    private func makePost() {
        post = InstagramVideoPost()
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
