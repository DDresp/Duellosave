//
//  InstagramImagesPostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol InstagramImagesPostModel: ApiImagesPostModel {
    var apiUrl: PostAttribute { get set }
    
}

extension InstagramImagesPostModel {
    
    func getApiUrl() -> String { return apiUrl.value as? String ?? "" }
    
    func setApiUrl(_ url: String) { apiUrl.value = url }
    
    var type: FineMediaEnum {
        return .instagramImages
    }
}
