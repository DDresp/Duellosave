//
//  LocalVideoPostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol LocalVideoPostModel: VideoPostModel {
    var videoUrl: PostSingleAttribute { get set }
    var thumbNailUrl: PostSingleAttribute { get set }
    
}

extension LocalVideoPostModel {
    
    func getVideoUrl() -> String {
        return videoUrl.value?.toStringValue() ?? ""
    }
    
    func getThumbnailUrl() -> String {
        return thumbNailUrl.value?.toStringValue() ?? ""
    }
    
    var type: MediaType {
        return .localVideo
    }
}
