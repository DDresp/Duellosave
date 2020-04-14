//
//  InstagramVideoPostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol InstagramVideoPostModel: ApiVideoPostModel {
    var apiUrl: PostAttribute { get set }
    
}

extension InstagramVideoPostModel {
    var type: FineMediaType {
        return .instagramVideo
    }
}
