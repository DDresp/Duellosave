//
//  InstagramService_Images.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

//MARK: - Images
extension InstagramService {
    
    func extractImageUrls(from description: String) -> [URL]? {
        var imageUrlStrings = getValuesForQueryKey(key: "display_url", from: description)
        guard imageUrlStrings.count > 0 else { return nil }
        
        //At the moment the instagram API returns the first image of a multiple image post twice
        if imageUrlStrings.count > 1 {
            imageUrlStrings.removeFirst()
        }
        
        let imageUrls = imageUrlStrings.map({ (urlString) -> (URL?) in
            return URL(string: urlString)
        })
        
        return imageUrls.compactMap{ $0 }
        
    }
    
    func downloadInstagramImagesPost(from link: String) -> Observable<RawInstagramPostType> {
        if !hasInternetConnection() { return Observable.error(InstagramError.networkError) }
        return downloadInstagramImageUrls(link: link).map({ (urls, ratio) -> RawInstagramPostType in
            if urls.count > 1 {
                return RawInstagramImagesPost(imageUrls: urls, mediaRatio: ratio, apiLink: link)
            } else {
                return RawInstagramSingleImagePost(singleImageUrl: urls.first!, mediaRatio: ratio, apiLink: link)
            }
        })
        
    }
    
    private func downloadInstagramImageUrls(link: String) -> Observable<([URL], Double)> {
        
        return downloadDescription(link: link).map({ [weak self] (description) -> ([URL], Double) in
            guard let imageUrls = self?.extractImageUrls(from: description) else { throw InstagramError.noImageUrl }
            let ratio = self?.extractMediaRatio(from: description) ?? 1
            return (imageUrls, ratio)
            })
    }
    
}
