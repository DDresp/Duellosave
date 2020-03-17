//
//  FetchingService.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import FirebaseFirestore
import RxSwift

class FetchingService: NetworkService {
    
    static let shared = FetchingService()
    
    private init() {}
    
    func fetchDic(for reference: CollectionReference, id: String) -> Observable<[String: Any]?> {
        
        return Observable.create({ (observer) -> Disposable in
            reference.document(id).getDocument(completion: { (snapshot, err) in
                if let err = err {
                    observer.onError(DownloadError.unknown(description: err.localizedDescription))
                    return
                }
                guard let doc = snapshot?.data() else {
                    observer.onNext(nil)
                    return
                }
                observer.onNext(doc)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    func fetchIds(reference: CollectionReference, orderKey: String, limit: Int, startId: String? = nil) -> Observable<[String]> {
        
        
        return Observable.create({ (observer) -> Disposable in
            
            var query = reference.order(by: orderKey, descending: true)
            
            if let id = startId, let document = MemoryManager.shared.retrieveSnapshot(from: reference.document(id).path) {
                query = query.start(afterDocument: document)
            }
            
            query = query.limit(to: limit)
            
            query.getDocuments(completion: { (snapshot, err) in
                if let err = err {
                    observer.onError(DownloadError(error: err))
                    return
                }
                
                guard let documents = snapshot?.documents else { return observer.onError(DownloadError.noData) }
                let ids = documents.map({ (document) -> String in
                    return document.documentID
                })
                
                if let lastDocument = documents.last {
                    let lastId = lastDocument.documentID
                    MemoryManager.shared.memorize(snapshot: lastDocument, with: reference.document(lastId).path)
                }
                
                observer.onNext(ids)
                observer.onCompleted()
            })
            
            return Disposables.create()
        })
    }

}
