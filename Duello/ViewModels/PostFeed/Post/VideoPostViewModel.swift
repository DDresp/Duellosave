//
//  VideoPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import AVFoundation

class VideoPostViewModel: PostViewModel, VideoPlayerDisplayer {
    
    //MARK: - Models
    var videoModel: VideoPostModel  {
        return post as! VideoPostModel
    }
    
    //MARK: - Bindables
    private var apiDownloadingTask: Observable<(URL?, URL?)>? //only relevant if video is fetched from API

    let videoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let videoAsset: BehaviorRelay<AVAsset?> = BehaviorRelay(value: nil)
    let thumbnailUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let thumbnailImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
    let playVideoRequested: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let startVideo: PublishRelay<AVAsset> = PublishRelay()
    
    let tappedVideo: PublishRelay<Void> = PublishRelay<Void>()
    let tappedSoundIcon: PublishRelay<Void> = PublishRelay<Void>()
    let isMuted: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Setup
    init(user: UserModel, post: VideoPostModel, index: Int) {
        
        switch post {
        case let post as LocalVideoPostModel:
            if let url1 = URL(string: post.getVideoUrlString()), let url2 = URL(string: post.getThumbnailUrlString()) {
                videoUrl.accept(url1)
                thumbnailUrl.accept(url2)
            }
        case let post as ApiVideoPostModel:
            self.apiDownloadingTask = post.downloadVideoUrlAndThumbnail()
        default:
            ()
        }
        super.init(user: user, post: post, index: index)
        setupBindables()
    }
    
    //MARK: - Reactive
    private func setupBindables() {
        setupVideoPlayerBindables()
        
        apiDownloadingTask?.subscribe(onNext: { [weak self] (instagramVideoUrl, thumbnailUrl) in
            self?.videoUrl.accept(instagramVideoUrl)
            self?.thumbnailUrl.accept(thumbnailUrl)
            }).disposed(by: disposeBag)
        
        showLikeView.filter { (showsLikeView) -> Bool in
            return showsLikeView
            }.map { (showsLikeView) -> Bool in
                return false
            }.bind(to: playVideoRequested).disposed(by: disposeBag)
    }
    
}
