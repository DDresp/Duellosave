//
//  FetchingService_CategoryPostFeed.swift
//  Duello
//
//  Created by Darius Dresp on 4/7/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxSwift

extension FetchingService {
    
    func fetchCategoryPosts(for cid: String, limit: Int?, startId: String?) -> Observable<[PostModel]> {
        
        var equalityConditions = [String: Any]()
        equalityConditions[PostAttributeCase.reportStatus.key] = ReportStatusType.noReport.toStringValue()
        equalityConditions[PostAttributeCase.cid.key] = cid
        equalityConditions[PostAttributeCase.isDeactivated.key] = false
        
        return fetchPosts(orderKey: PostAttributeCase.creationDate.key, limit: limit, startId: startId, equalityConditions: equalityConditions).map { (posts) -> [PostModel] in
            var orderedPosts = posts
            orderedPosts.sort(by: { (post1, post2) -> Bool in
                guard let creationDate1 = Double(post1.creationDate.value?.toStringValue() ?? "0") else { return true }
                guard let creationDate2 = Double(post2.creationDate.value?.toStringValue() ?? "0") else { return true }
                return (creationDate1 > creationDate2)
            })
            return orderedPosts
        }
    }
    

}
