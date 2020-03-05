//
//  StoringService.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import Firebase

class StoringService: NetworkService {
    
    static let shared = StoringService()
    
    private init() {}
    
    func uploadData(data: Data, reference: StorageReference) -> Observable<Bool> {
        
        return Observable.create({ (observer) -> Disposable in
            
            let uploadTask = reference.putData(data)
            reference.storage.maxUploadRetryTime = 10
            
            uploadTask.observe(.success, handler: { (snapshot) in
                if let error = snapshot.error {
                    observer.onError(StoringError(error: error))
                    return
                }
                
                observer.onNext(true)
                observer.onCompleted()
                
            })
            
            uploadTask.observe(.failure, handler: { (snapshot) in
                observer.onError(StoringError.networkError)
            })
            
            return Disposables.create()
            
        })
        
    }
    
    func uploadFile(url: URL, reference: StorageReference) -> Observable<Bool> {
        
        return Observable.create({ (observer) -> Disposable in
            
            let uploadTask = reference.putFile(from: url)
            reference.storage.maxUploadRetryTime = 15
            
            uploadTask.observe(.success, handler: { (snapshot) in
                if let error = snapshot.error {
                    observer.onError(StoringError(error: error))
                    return
                }
                
                observer.onNext(true)
                observer.onCompleted()
            })
            
            uploadTask.observe(.failure, handler: { (snapshot) in
                observer.onError(StoringError.networkError)
            })
            
            return Disposables.create()
    
        })
    }
    
    func downloadURL(from reference: StorageReference) -> Observable<String> {
        
        return Observable.create({ (observer) -> Disposable in
            reference.downloadURL { (url, err) in
                if let _ = err {
                    observer.onError(StoringError.networkError)
                    return
                }
                guard let urlString = url?.absoluteString else {
                    observer.onError(StoringError.unknown(description: "unknown error"))
                    return
                }
                
                observer.onNext(urlString)
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
        
    }

}
