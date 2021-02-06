//
//  VideoPostCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import AVKit
import RxSwift
import RxCocoa

class VideoPostCell: PostCell {

    //MARK: - Displayer
    var videoPostDisplayer: VideoPostDisplayer? {
        return displayer as? VideoPostDisplayer
    }
    
    //MARK: - Views
    lazy var videoPlayer: VideoPlayer = {
        let player = VideoPlayer()
        player.addGestureRecognizer(doubleTapGesture)
        player.oneTapGesture.require(toFail: doubleTapGesture)
        return player
    }()
    
    override var mediaView: UIView {
        get {
            return videoPlayer
        }
        set {}
    }
    
    //MARK: - Methods
    override func configure() {
        super.configure()
        videoPlayer.displayer = videoPostDisplayer
    }
}


//import AVKit
//import RxSwift
//import RxCocoa
//
//class VideoPostCell: PostCell<VideoPostViewModel> {
//
//    //MARK: - Views
//    lazy var videoPlayer: VideoPlayer = {
//        let player = VideoPlayer()
//        player.addGestureRecognizer(doubleTapGesture)
//        player.oneTapGesture.require(toFail: doubleTapGesture)
//        return player
//    }()
//
//    override var mediaView: UIView {
//        get {
//            return videoPlayer
//        }
//        set {}
//    }
//
//    //MARK: - Methods
//    override func configure() {
//        super.configure()
//        videoPlayer.displayer = displayer
//    }
//}
