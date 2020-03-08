//
//  VideoPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

//Video LOGIC: starts downloading video when the cell appears and not when the user tapped the video. The download of the video should be canceled if the videoPost disappears from the view (the cacheService in the background should pause the download instead of fully canceling).

class VideoPostViewModel: PostViewModel, VideoPlayerDisplayer {
    
    //MARK: - Models
    var videoModel: VideoPostModel  {
        return post as! VideoPostModel
    }
    
    //MARK: - Bindables
    private var apiDownloadingTask: Observable<(URL?, URL?)>?

    var videoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    var thumbnailUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    var thumbnailImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
    var playVideoRequested: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var removeVideo: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var tappedVideo: PublishRelay<Void> = PublishRelay<Void>()
    
    var shouldDownload: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var shouldPlayVideo: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showThumbnailImage: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    var isMuted: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    var tappedSoundIcon: PublishRelay<Void> = PublishRelay<Void>()
    var startedPlayingOtherCell: PublishRelay<Void> = PublishRelay<Void>()
    
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
        setupUIBindables()
        setupBindablesFromOwnProperties()
        
    }
    
    //MARK: - Reactive
    private func setupUIBindables() {
        
        tappedVideo.withLatestFrom(playVideoRequested).map { (playVideoRequested) -> Bool in
            return !playVideoRequested
            }.bind(to: playVideoRequested).disposed(by: disposeBag)
        
        tappedSoundIcon.withLatestFrom(isMuted).map { (isMuted) -> Bool in
            return !isMuted
            }.bind(to: isMuted).disposed(by: disposeBag)
        
        //Start downloading before user requested it to enhance the user experience (faster download for user)
        willBeDisplayed.asObservable().map { (_) -> Bool in
            return true
            }.bind(to: shouldDownload).disposed(by: disposeBag)
        
        didDisappear.map { (_) -> Bool in
            return false
            }.bind(to: playVideoRequested).disposed(by: disposeBag)
        
        didDisappear.map { (_) -> Bool in
            return false
            }.bind(to: shouldDownload).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesFromOwnProperties() {
        
        playVideoRequested.filter { (playVideoRequested) -> Bool in
            return !playVideoRequested
            }.bind(to: shouldPlayVideo).disposed(by: disposeBag)
        
        playVideoRequested.map { (playVideoRequested) -> Bool in
            return !playVideoRequested
            }.bind(to: showThumbnailImage).disposed(by: disposeBag)
        
        Observable.combineLatest(playVideoRequested, videoUrl).asObservable().filter { (playVideo, videoUrl) -> Bool in
            return playVideo && (videoUrl != nil)
        }.map { (_) -> Bool in
            return true
            }.bind(to: shouldPlayVideo).disposed(by: disposeBag)
        
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
    
    deinit {
        playVideoRequested.accept(false)
    }
    
}
