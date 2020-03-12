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

    var videoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    var videoAsset: BehaviorRelay<AVAsset?> = BehaviorRelay(value: nil)
    var thumbnailUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    var thumbnailImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
    var playVideoRequested: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var startVideo: PublishRelay<AVAsset> = PublishRelay()
    
    var tappedVideo: PublishRelay<Void> = PublishRelay<Void>()
    var tappedSoundIcon: PublishRelay<Void> = PublishRelay<Void>()
    var isMuted: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    
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
    
    //MARK: - Networking
    private func downloadVideoAsset(for url: URL) -> (){
        
        let asset = AVAsset(url: url)
        let keys = ["playable"]
        
        asset.loadValuesAsynchronously(forKeys: keys) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                self.videoAsset.accept(asset)
                break
            default:
                break
            }
        }
    }
    
    //MARK: - Reactive
    private func setupUIBindables() {
        
        tappedVideo.withLatestFrom(playVideoRequested).map { (playVideoRequested) -> Bool in
            return !playVideoRequested
            }.bind(to: playVideoRequested).disposed(by: disposeBag)
        
        tappedSoundIcon.withLatestFrom(isMuted).map { (isMuted) -> Bool in
            return !isMuted
            }.bind(to: isMuted).disposed(by: disposeBag)
        
        didDisappear.map { (_) -> Bool in
            return false
            }.bind(to: playVideoRequested).disposed(by: disposeBag)
        
    }

    private func setupBindablesFromOwnProperties() {
        
        Observable.combineLatest(playVideoRequested, videoAsset).filter { (playVideoRequested, videoAsset) -> Bool in
            return playVideoRequested && (videoAsset != nil)
        }.flatMap { (_, asset) -> Observable<AVAsset> in
            return Observable.from(optional: asset)
        }.bind(to: startVideo).disposed(by: disposeBag)
        
        Observable.combineLatest(playVideoRequested, videoUrl, videoAsset).filter { (playVideoRequested, videoUrl, videoAsset) -> Bool in
            return playVideoRequested && (videoUrl != nil) && (videoAsset == nil)
        }.flatMap { (_, videoUrl, _) -> Observable<URL> in
            return Observable.from(optional: videoUrl)
        }.subscribe(onNext: { [weak self] (url) in
            self?.downloadVideoAsset(for: url)
        }).disposed(by: disposeBag)
        
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
