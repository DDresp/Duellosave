//
//  InstagramVideoPostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol InstagramVideoPostModel: ApiVideoPostModel {
    var apiUrl: PostSingleAttribute { get set }
    
}

extension InstagramVideoPostModel {
    var type: MediaType {
        return .instagramVideo
    }
}
