//
//  LocalImagesPostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

protocol LocalImagesPostModel: ImagesPostModel
{
    var imageUrls: PostAttribute { get set }
}

extension LocalImagesPostModel {
    
    var type: FineMediaType {
        return .localImages
    }
    
    func getImageURLS() -> [URL]? {
        guard let imageUrlStrings = imageUrls.value as? [String] else { return nil }
        let imageUrls = imageUrlStrings.compactMap { (imageUrlString) -> URL? in
            return URL(string: imageUrlString)
        }
        
        return imageUrls
    }
    
}
