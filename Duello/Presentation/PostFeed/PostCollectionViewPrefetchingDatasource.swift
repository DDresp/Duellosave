//
//  PostCollectionViewPrefetchingDatasource.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit
import Firebase

class PostCollectionViewPrefetchingDatasource: NSObject, UICollectionViewDataSourcePrefetching {
    
    //MARK: - Displayer
    let displayer: FeedDisplayer
    
    //MARK: - Child Displayers
    var postsDisplayer: PostCollectionDisplayer {
        return displayer.postCollectionDisplayer
    }
    
    //MARK: - Setup
    init(displayer: FeedDisplayer) {
        self.displayer = displayer
        super.init()
    }
    
    //MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        postsDisplayer.prefetchingIndexPaths.accept(indexPaths)
    }
    
}
