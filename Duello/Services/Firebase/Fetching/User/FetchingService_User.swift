//
//  FetchingService_User.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import Firebase

extension FetchingService {
    
    func fetchUser(for uid: String) -> Observable<UserModel> {
        return fetchDic(for: USERS_REFERENCE, id: uid)
            .map { (data) -> UserModel in
                guard let data = data else { throw DownloadError.noData }
                return self.configureUser(data: data, uid: uid)
        }
    }
    
    private func configureUser(data: [String: Any], uid: String) -> UserModel {
        var user = User()
        user.configure(with: data, id: uid)
        return user
    }
    
}
