//
//  FeedDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol FeedDisplayer {
    
    //MARK: - ChildDisplayers
    var userHeaderDisplayer: UserHeaderDisplayer? { get }
    var postCollectionDisplayer: PostCollectionDisplayer { get }
    
    //MARK: - Bindables
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var showAlert: PublishRelay<Alert> { get }
    var showLoading: BehaviorRelay<Bool> { get }

}

extension FeedDisplayer {
    //Getter
    var hasProfileHeader: Bool {return userHeaderDisplayer != nil }
}
