//
//  StoringService_Images.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import Firebase

extension StoringService {
    
    func storeSingleImage(image: UIImage) -> Observable<String> {
        if !hasInternetConnection() { return Observable.error(StoringError.networkError) }
        return uploadImage(image: image, path: "/postImages/")
        
    }
    
    func storeImages(images: [UIImage]) -> Observable<[String]> {
        if !hasInternetConnection() { return Observable.error(StoringError.networkError) }
        var observables = [Observable<String>]()
        for image in images {
            observables.append(uploadImage(image: image, path: "/postImages/"))
        }
        return Observable.zip(observables)
    }
    
    func storeProfileImage(image: UIImage) -> Observable<String> {
        if !hasInternetConnection() { return Observable.error(StoringError.networkError) }
        return uploadImage(image: image, path: "/profileImages/")
        
    }
    
    func storeThumbnailImage(image: UIImage) -> Observable<String> {
        if !hasInternetConnection() { return Observable.error(StoringError.networkError) }
        return uploadImage(image: image, path: "/postThumbNailImages/")
    }
    
    private func uploadImage(image: UIImage, path: String) -> Observable<String> {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: path + filename)
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return Observable.error(StoringError.failedImageCompression) }
        
        return uploadData(data: imageData, reference: ref).filter({ (success) -> Bool in
            return success
        }).flatMap({ (_) in
            return self.downloadURL(from: ref)
        })
        
    }
    
}
