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
    
    func downloadInstagramImagesPost(from link: String) -> Observable<RawInstagramPostType> {
        if !hasInternetConnection() { return Observable.error(InstagramError.networkError) }
        
        return downloadInstagramImageUrls(link: link).map({ (urls) -> RawInstagramPostType in
            if urls.count > 1 {
                return RawInstagramImagesPost(imageUrls: urls, apiLink: link)
            } else {
                return RawInstagramSingleImagePost(singleImageUrl: urls.first!, apiLink: link)
            }
        })
        
    }
    
    private func downloadInstagramImageUrls(link: String) -> Observable<[URL]> {
        return downloadDescription(link: link).map({ [weak self] (description) -> [URL] in
            
            guard var imageUrlStrings = self?.getValuesForQueryKey(key: "display_url", from: description), imageUrlStrings.count > 0 else { throw InstagramError.noImageUrl }
            
            //At the moment the instagram API returns the first image of a multiple image post twice
            if imageUrlStrings.count > 1 {
                imageUrlStrings.removeFirst()
            }
            
            let imageUrls = imageUrlStrings.map({ (urlString) -> URL? in
                return URL(string: urlString)
            })
            
            return imageUrls.compactMap{ $0 }
        })
        
    }
    
}
