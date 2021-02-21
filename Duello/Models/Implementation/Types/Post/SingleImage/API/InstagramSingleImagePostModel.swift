//
//  InstagramSingleImagePostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol InstagramSingleImagePostModel: ApiSingleImagePostModel {
    var apiUrl: PostAttribute { get set }
}

extension InstagramSingleImagePostModel {
    
    func getApiUrl() -> String { return apiUrl.getValue() as? String ?? "" }
    
    func setApiUrl(_ url: String) { apiUrl.setValue(of: url) }
    
    var type: FineMediaEnum {
        return .instagramSingleImage
    }
}
