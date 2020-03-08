//
//  LocalSingeImagePostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

protocol LocalSingleImagePostModel: SingleImagePostModel {
    var imageUrl: PostSingleAttribute { get set }
}

extension LocalSingleImagePostModel {
    
    var type: MediaType {
        return .localSingleImage
    }
    
    func getSingleImageUrl() -> URL? {
        return URL(string: imageUrl.value?.toStringValue() ?? "")
    }
}