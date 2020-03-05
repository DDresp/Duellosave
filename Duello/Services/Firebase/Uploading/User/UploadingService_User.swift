//
//  UploadingService_User.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import Firebase

extension UploadingService {
    
    func saveUser(userProfile: UserModel) -> Observable<Model?> {
        guard hasInternetConnection() else { return Observable.error(UploadError.networkError)}
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(UploadError.userNotLoggedIn)}
        
        return saveDatabaseModel(databaseModel: userProfile, reference: USERS_REFERENCE, id: uid).map({ (databaseModel) -> Model? in
            return databaseModel
        })
        
    }
    
}
