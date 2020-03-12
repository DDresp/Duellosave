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
    
    //MARK: - Child Displayers
    var userHeaderDisplayer: UserHeaderDisplayer? { get }
    var postCollectionDisplayer: PostCollectionDisplayer { get }
    
    //MARK: - Bindables
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var showAlert: PublishRelay<Alert> { get }
    var showLoading: BehaviorRelay<Bool> { get }
//    var viewDidDisappear: PublishRelay<Void> { get }
    var viewIsAppeared: BehaviorRelay<Bool> { get }
//    var viewDidAppear: PublishRelay<Void> { get }
    var didStart: BehaviorRelay<Bool> { get }
    
    func startFetching() -> ()

}

extension FeedDisplayer {
    //Getter
    var hasProfileHeader: Bool {return userHeaderDisplayer != nil }
}
