//
//  NetworkService.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Alamofire
import RxSwift

protocol NetworkService {}

extension NetworkService {
    
    func hasInternetConnection() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func checkInternetConnection<T>(type: T.Type) -> Observable<T>? {
        if hasInternetConnection() { return nil }
        return Observable.error(UploadingError.networkError)
    }
}
