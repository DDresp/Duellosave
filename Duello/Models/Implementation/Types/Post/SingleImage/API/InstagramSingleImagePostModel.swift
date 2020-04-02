//
//  InstagramSingleImagePostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol InstagramSingleImagePostModel: ApiSingleImagePostModel {
    var apiUrl: PostSingleAttribute { get set }
}

extension InstagramSingleImagePostModel {
    var type: FineMediaType {
        return .instagramSingleImage
    }
}
