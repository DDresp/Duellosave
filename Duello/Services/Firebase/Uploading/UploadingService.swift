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
                    observer.onError(UploadingError(error: error))
                    return
                }
                
                observer.onNext(databaseModel)
                observer.onCompleted()
                return
            })
            return Disposables.create()
            
        })
    }
    
    func saveDictionary(dic: [String: Any], reference: CollectionReference, id: String) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            reference.document(id).setData(dic) { (error) in
                if let error = error {
                    print(error, error.localizedDescription)
                    observer.onError(UploadingError(error: error))
                    return
                }
                
                observer.onNext(())
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
