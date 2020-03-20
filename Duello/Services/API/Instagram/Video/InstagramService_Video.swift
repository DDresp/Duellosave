//
//  InstagramService_Video.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
//


import RxSwift
import AVFoundation

//MARK: - Video
extension InstagramService {
    
    func downloadInstagramVideoPost(from link: String) -> Observable<RawInstagramVideoPost> {
        
        if !hasInternetConnection() { return Observable.error(InstagramError.networkError) }
        
        return downloadInstagramVideoURLandThumbnailURL(link: link).map({ (videoUrl, thumbnailUrl, ratio) -> RawInstagramVideoPost in
            return RawInstagramVideoPost(videoURL: videoUrl, thumbnailUrl: thumbnailUrl, apiLink: link, mediaRatio: ratio)
        })
    }
    
    private func downloadInstagramVideoURLandThumbnailURL(link: String) -> Observable<(URL, URL, Double)> {
        
        return downloadDescription(link: link).map({ [weak self] (description) -> (URL, URL, Double) in
            guard let videoUrlString = self?.getValuesForQueryKey(key: "video_url", from: description).first else { throw InstagramError.noVideoUrl }
            guard let thumbnailUrlString = self?.getValuesForQueryKey(key: "thumbnail_src", from: description).first else { throw InstagramError.noThumbnail }
            guard let videoUrl = URL(string: videoUrlString) else { throw InstagramError.noVideoUrl}
            guard let thumbnailUrl = URL(string: thumbnailUrlString) else { throw InstagramError.noThumbnail }
            let ratio = self?.extractMediaRatio(from: description) ?? 1
            return (videoUrl, thumbnailUrl, ratio)
            
        })
        
    }
    
}
