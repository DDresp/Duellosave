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
    var imageUrls: PostMapAttribute { get set }
}

extension LocalImagesPostModel {
    
    var type: MediaType {
        return .localImages
    }
    
    func getImageURLS() -> [URL]? {
        
        guard let images = imageUrls.getModel() as? LocalImages else { return nil }
        var imageUrls = [URL]()
        let attributes = [images.imageUrl1, images.imageUrl2, images.imageUrl3, images.imageUrl4, images.imageUrl5, images.imageUrl6]
        for attribute in attributes {
            
            if let string = attribute.value?.toStringValue(), let url = URL(string: string) {
                imageUrls.append(url)
            }
        }
        return imageUrls
    }
}
