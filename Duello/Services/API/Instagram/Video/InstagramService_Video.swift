//
//  InstagramService_Video.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import AVFoundation

//MARK: - Video
extension InstagramService {
    
    func downloadInstagramVideoPost(from link: String) -> Observable<RawInstagramVideoPost> {
        
        if !hasInternetConnection() { return Observable.error(InstagramError.networkError) }
        
        return downloadInstagramVideoURL(link: link).map({ [weak self] (videoUrl) -> RawInstagramVideoPost in
            guard let image = self?.makeInstagramVideoThumbnail(from: videoUrl) else { throw InstagramError.failedThumbnail}
            return RawInstagramVideoPost(videoURL: videoUrl, thumbnailImage: image, apiLink: link)
        })
    }
    
    private func downloadInstagramVideoURL(link: String) -> Observable<URL> {
        
        return downloadDescription(link: link).map({ [weak self] (description) -> URL in
            guard let urlString = self?.getValuesForQueryKey(key: "video_url", from: description).first else { throw InstagramError.noVideoUrl }
            guard let url = URL(string: urlString) else { throw InstagramError.noVideoUrl}
            return url
        })
        
    }
    
    private func makeInstagramVideoThumbnail(from videoUrl: URL) -> UIImage? {
        //Todo: ATTENTION
        return #imageLiteral(resourceName: "image5")
        let asset = AVAsset(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print("debug: error \(error.localizedDescription)")
            return nil
        }
    }
    
}
