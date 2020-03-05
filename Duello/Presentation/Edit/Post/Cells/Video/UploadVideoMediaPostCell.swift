//
//  UploadVideoMediaPostCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import AVKit
import RxSwift

class UploadVideoMediaPostCell: UITableViewCell {
    
    //MARK: - Displayer
    var displayer: UploadVideoPostDisplayer? {
        didSet {
            videoPlayer.displayer = displayer
        }
    }
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = EXTREMELIGHTGRAYCOLOR
        addSubview(videoPlayer)
        videoPlayer.fillSuperview()

    }
    
    //MARK: - Views
    private let videoPlayer: VideoPlayer = {
        let player = VideoPlayer()
        return player
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
