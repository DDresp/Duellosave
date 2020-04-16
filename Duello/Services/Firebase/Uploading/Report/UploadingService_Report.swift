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
    
//    func createInappropriateReport(postId: String) -> Observable<Void> {
//        return createReport(postId: postId, reportCategory: INAPPROPRIATE_REPORT)
//    }
//
//    func createWrongCategoryReport(postId: String) -> Observable<Void> {
//        return createReport(postId: postId, reportCategory: IN_WRONG_CATEGORY_REPORT)
//    }
//
//    func createFromFakeUserReport(postId: String) -> Observable<Void> {
//        return createReport(postId: postId, reportCategory: FROM_FAKE_USER_REPORT)
//    }
//
//    private func createReport(postId: String, reportCategory: String) -> Observable<Void> {
//        guard hasInternetConnection() else { return Observable.error(UploadingError.networkError)}
//        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(UploadingError.userNotLoggedIn)}
//
//        let reference = USERS_REFERENCE.document(uid).collection(reportCategory)
//
//        return self.saveDictionary(dic: [String : Any](), reference: reference, id: postId)
//    }
    
    func createReport(postId: String, report: ReportType) -> Observable<Void> {
        guard hasInternetConnection() else { return Observable.error(UploadingError.networkError)}
        guard let uid = Auth.auth().currentUser?.uid else { return Observable.error(UploadingError.userNotLoggedIn)}
        
        let reference = USERS_REFERENCE.document(uid).collection(USER_REPORTED_POSTS_COLLECTION)
        
        let reportDic = ["report": report.toStringValue()]
        
        return self.saveDictionary(dic: reportDic, reference: reference, id: postId)
    }
    
}
