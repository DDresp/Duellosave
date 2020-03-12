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

protocol VideoPlayerDisplayer {
    
    //MARK: - Variables
//    var loadedVideo: Bool { get set }
    
    //MARK: - Bindables
    var videoUrl: BehaviorRelay<URL?> { get }
    var thumbnailUrl: BehaviorRelay<URL?> { get }
    var thumbnailImage: BehaviorRelay<UIImage?> { get }

    //Observable from View
    var tappedSoundIcon: PublishRelay<Void> { get }
    var tappedVideo: PublishRelay<Void> { get }

    var isMuted: BehaviorRelay<Bool> { get }
    
//    var playVideo: BehaviorRelay<Bool> { get }
//    var flipThumbnailImage: BehaviorRelay<Bool> { get }
    var playVideoRequested: BehaviorRelay<Bool> { get }
//    var playVideo: PublishRelay<Bool> { get }
    var startVideo: PublishRelay<AVAsset> { get }
//    var showThumbnailImage: BehaviorRelay<Bool> { get }
    
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
    
}
