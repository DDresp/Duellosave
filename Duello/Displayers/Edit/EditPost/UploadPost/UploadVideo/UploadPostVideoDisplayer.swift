//
//  UploadPostVideoDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//ATTENTION
protocol UploadVideoPostDisplayer: UploadPostDisplayer, VideoPlayerDisplayer {}

extension UploadVideoPostDisplayer {
    
    //MARK: - Reactive
    func setupBasicBindables() {
    
        tappedSoundIcon.withLatestFrom(isMuted).map { (wasMuted) -> Bool in
            return !wasMuted
            }.bind(to: isMuted).disposed(by: disposeBag)
        
//        tappedVideo.withLatestFrom(playVideo).map { (shouldPlayVideo) -> Bool in
//            return !shouldPlayVideo
//            }.bind(to: playVideo).disposed(by: disposeBag)
        
//        playVideo.map { (shouldPlayVideo) -> Bool in
//            return !shouldPlayVideo
//            }.bind(to: showThumbnailImage).disposed(by: disposeBag)
        
//        willDisappear.map { (_) -> Bool in
//            return false
//            }.bind(to: playVideo).disposed(by: disposeBag)
    }
    
}
