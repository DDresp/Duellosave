//
//  StoringService_Video.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import Firebase

extension StoringService {
    
    func storeVideoAndThumbnail(image: UIImage, videoUrl: URL) -> Observable<[String]> {
        guard hasInternetConnection() else { return Observable.error(StoringError.networkError)}
        let observables = [storeThumbnailImage(image: image), storeVideo(videoUrl: videoUrl)]
        return Observable.zip(observables)
    }
    
    private func storeVideo(videoUrl: URL) -> Observable<String> {
        return uploadVideo(videoUrl: videoUrl, path: "/postVideos")
    }
    
    private func uploadVideo(videoUrl: URL, path: String) -> Observable<String> {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: path + filename)
        
        return uploadFile(url: videoUrl, reference: ref).filter({ (success) -> Bool in
            return success
        }).flatMap({ (_) in
            return self.downloadURL(from: ref)
        })
    }
    
}
