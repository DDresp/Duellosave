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
    private var apiDownloadingTask: Observable<(String?, UIImage?)>?
    
    private var remoteVideoUrl: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var remoteThumbnailUrlString: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    var localVideoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    var localThumbnailImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
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
            self.remoteVideoUrl.accept(post.getVideoUrl())
            self.remoteThumbnailUrlString.accept(post.getThumbnailUrl())
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
        
        let willDisappear = Observable.of(didEndDisplaying, viewDidDisappear).merge().asObservable().share(replay: 2, scope: .whileConnected)
        willDisappear.map { (_) -> Bool in
            return false
            }.bind(to: playVideoRequested).disposed(by: disposeBag)
        willDisappear.map { (_) -> Bool in
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
        
        Observable.combineLatest(playVideoRequested, localVideoUrl) { (playVideoRequested, videoUrl) -> (Bool, URL?) in
            return (playVideoRequested, videoUrl)
            }.filter { (playVideoRequested, videoUrl) -> Bool in
                return playVideoRequested && videoUrl != nil
            }.map { (_) -> Bool in
                return true
            }.bind(to: shouldPlayVideo).disposed(by: disposeBag)
        
        Observable.combineLatest(shouldDownload, remoteVideoUrl) { (shouldDownload, remoteUrl) -> (Bool, String?) in
            return (shouldDownload, remoteUrl)
            }.subscribe(onNext: { (shouldDownload, remoteUrl) in
                guard let remoteUrl = remoteUrl else { return }
                if shouldDownload {
                    VideoCacheManager.shared.downloadVideo(stringUrl: remoteUrl, completionHandler: { [weak self] (result) in
                        switch result {
                        case .success(let url):
                            self?.localVideoUrl.accept(url)
                        case .failure(_):
                            ()
                        }
                    })
                } else {
                    VideoCacheManager.shared.cancelVideoDownload(stringUrl: remoteUrl)
                }
            }).disposed(by: disposeBag)
        
        apiDownloadingTask?.subscribe(onNext: { [weak self] (instagramVideoUrl, thumbnailImage) in
            self?.remoteVideoUrl.accept(instagramVideoUrl)
            self?.localThumbnailImage.accept(thumbnailImage)
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
