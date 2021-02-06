//
//  UploadingService_Follow.swift
//  Duello
//
//  Created by Darius Dresp on 8/10/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift
import RxCocoa

extension UploadingService {
    
    func followCategory(categoryId: String) -> Observable<Void> {
        guard hasInternetConnection() else { return Observable.error(UploadingError.networkError)}
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(UploadingError.userNotLoggedIn)}
        
        let reference = USERS_REFERENCE.document(uid).collection(USER_FOLLOWED_CATEGORIES_COLLECTION)
        
        return self.saveDictionary(dic: [String: Any](), reference: reference, id: categoryId)
    }
    
}

