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
    
    func fetchDocuments(for reference: CollectionReference, field: String?, key: String?, orderKey: String, limit: Int?, startId: String?) -> Observable<[QueryDocumentSnapshot]?> {
        return Observable.create { (observer) -> Disposable in
            
            var query: Query
            
            if let field = field, let key = key {
                query = reference.whereField(field, isEqualTo: key).order(by: orderKey, descending: true)
            } else {
                query = reference.order(by: orderKey, descending: true)
            }
            
            if let id = startId, let document = MemoryManager.shared.retrieveSnapshot(from: (key ?? "") + reference.document(id).path) {
                query = query.start(afterDocument: document)
            }
            
            if let limit = limit {
                query = query.limit(to: limit)
            }
            
            query.getDocuments { (snapshot, err) in
                if let err = err {
                    observer.onError(DownloadError(error: err))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    return observer.onError(DownloadError.noData)
                }
                
                if let lastDocument = documents.last {
                    let lastId = lastDocument.documentID
                    MemoryManager.shared.memorize(snapshot: lastDocument, with: (key ?? "") + reference.document(lastId).path)
                }
                
                observer.onNext(documents)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
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
    
}
