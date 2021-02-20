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
        equalityConditions[PostAttributeType.reportStatus.key] = PostReportStatusEnum.noReport.rawValue
        equalityConditions[PostAttributeType.cid.key] = cid
        equalityConditions[PostAttributeType.isDeactivated.key] = false
        
        return fetchPosts(orderKey: PostAttributeType.creationDate.key, limit: limit, startId: startId, equalityConditions: equalityConditions).map { (posts) -> [PostModel] in
            var orderedPosts = posts
            orderedPosts.sort(by: { (post1, post2) -> Bool in
                let creationDate1 = post1.getCreationDate()
                let creationDate2 = post2.getCreationDate()
                return (creationDate1 > creationDate2)
            })
            return orderedPosts
        }
    }
    

}
