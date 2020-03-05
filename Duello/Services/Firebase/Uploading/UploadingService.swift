//
//  UploadingService.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift
import Alamofire

class UploadingService: NetworkService {
    
    static let shared = UploadingService()
    
    private init() {}
    
    func saveDatabaseModel(databaseModel: Model, reference: CollectionReference, id: String) -> Observable<Model?> {
        return Observable.create({(observer) -> Disposable in
            
            let docData = databaseModel.getUploadDictionary()
            
            reference.document(id).setData(docData, completion: { (error) in
                if let error = error {
                    print(error, error.localizedDescription)
                    observer.onError(UploadError(error: error))
                    return
                }
                
                observer.onNext(databaseModel)
                observer.onCompleted()
                return
            })
            return Disposables.create()
            
        })
    }
    
    func saveQueryRelation(databaseModel: Model, reference: CollectionReference, fromId: String , collectionName: String ,toId: String) -> Observable<Bool> {
        
        guard let docData = databaseModel.getUploadQueryKeys() else {
            return Observable.error(UploadError.unknown(description: "unknown error"))
        }
        
        return Observable.create({(observer) -> Disposable in
            
            let ref = reference.document(fromId).collection(collectionName).document(toId)
            
            ref.setData(docData, completion: { (err) in
                if let err = err {
                    observer.onError(UploadError(error: err))
                    return
                }
                
                observer.onNext(true)
                observer.onCompleted()
            })
            
            return Disposables.create()
        })
    }
    
}
