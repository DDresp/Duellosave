//
//  LocalVideoPostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol LocalVideoPostModel: VideoPostModel {
    var videoUrl: PostAttribute { get set }
    var thumbNailUrl: PostAttribute { get set }
    
}

extension LocalVideoPostModel {
    
    func getVideoUrlString() -> String {
        return videoUrl.getValue() as? String ?? ""
    }
    
    func getThumbnailUrlString() -> String {
        return thumbNailUrl.getValue() as? String ?? ""
    }
    
    func setVideoUrl(_ url: String) { videoUrl.setValue(of: url) }
    func setThumbnailUrl(_ url: String) { thumbNailUrl.setValue(of: url) }
    
    var type: FineMediaEnum {
        return .localVideo
    }
}
