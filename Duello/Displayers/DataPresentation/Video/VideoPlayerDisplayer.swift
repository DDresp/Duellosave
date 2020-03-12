//
//  VideoPlayerDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import AVFoundation

protocol VideoPlayerDisplayer: class {
    
    //MARK: - Bindables
    var videoUrl: BehaviorRelay<URL?> { get }
    var videoAsset: BehaviorRelay<AVAsset?> { get }
    var thumbnailUrl: BehaviorRelay<URL?> { get }
    var thumbnailImage: BehaviorRelay<UIImage?> { get }
    
    var playVideoRequested: BehaviorRelay<Bool> { get }
    var isMuted: BehaviorRelay<Bool> { get }
    var startVideo: PublishRelay<AVAsset> { get }

    //Observable from View
    var tappedSoundIcon: PublishRelay<Void> { get }
    var tappedVideo: PublishRelay<Void> { get }

    //MARK: - Reactive
    var disposeBag: DisposeBag { get }
    
}

extension VideoPlayerDisplayer {
    
    //MARK: - Getters
    func getVideoUrl() -> URL? {
        return videoUrl.value
    }
    
    func getThumbnailImage() -> UIImage? {
        return thumbnailImage.value
    }
    
    func getThumbnailUrl() -> URL? {
        return thumbnailUrl.value
    }
    
    //MARK: - Methods
    func downloadVideoAsset(for url: URL) -> (){
        
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
    func setupBasicVideoBindables() {
        tappedVideo.withLatestFrom(playVideoRequested).map { (playVideoRequested) -> Bool in
            return !playVideoRequested
            }.bind(to: playVideoRequested).disposed(by: disposeBag)
        
        tappedSoundIcon.withLatestFrom(isMuted).map { (isMuted) -> Bool in
            return !isMuted
            }.bind(to: isMuted).disposed(by: disposeBag)
        
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
    }
    
}
