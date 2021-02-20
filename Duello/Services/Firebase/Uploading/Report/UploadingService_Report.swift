//
//  UploadingService_Report.swift
//  Duello
//
//  Created by Darius Dresp on 4/15/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift
import RxCocoa

extension UploadingService {
    
    func createPostReport(postId: String, report: PostReportStatusEnum) -> Observable<Void> {
        return createReport(id: postId, value: report.rawValue, collection: USER_REPORTED_POSTS_COLLECTION)
    }
    
    func createCategoryReport(categoryId: String, report: CategoryReportStatusEnum) -> Observable<Void> {
        return createReport(id: categoryId, value: report.rawValue, collection: USER_REPORTED_CATEGORIES_COLLECTION)
        
    }
    
    private func createReport(id: String, value: String, collection: String) -> Observable<Void> {
        guard hasInternetConnection() else { return Observable.error(UploadingError.networkError)}
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(UploadingError.userNotLoggedIn)}
        
        let reference = USERS_REFERENCE.document(uid).collection(collection)
        let reportDic = ["reportStatus": value]
        
        return self.saveDictionary(dic: reportDic, reference: reference, id: id)
    }
    
}
