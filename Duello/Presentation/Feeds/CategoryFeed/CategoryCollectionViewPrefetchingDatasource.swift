//
//  CategoryCollectionViewPrefetchingDatasource.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit
import Firebase

class CategoryCollectionViewPrefetchingDatasource: NSObject, UICollectionViewDataSourcePrefetching {
    
    //MARK: - Displayer
    let displayer: CategoryCollectionDisplayer
    
    //MARK: - Setup
    init(displayer: CategoryCollectionDisplayer) {
        self.displayer = displayer
        super.init()
    }
    
    //MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        displayer.requestDataForIndexPath.accept(indexPaths)
    }
    
}
