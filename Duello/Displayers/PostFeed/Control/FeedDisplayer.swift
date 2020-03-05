//
//  FeedDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

protocol FeedDisplayer {
    
    //MARK: - ChildDisplayers
    var userHeaderDisplayer: UserHeaderDisplayer? { get }
    var postCollectionDisplayer: PostCollectionDisplayer { get }
    
}

extension FeedDisplayer {
    //Getter
    var hasProfileHeader: Bool {return userHeaderDisplayer != nil }
}
