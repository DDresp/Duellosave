//
//  SocialMediaDatasource.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit
import Firebase

class SocialMediaDatasource: NSObject, UICollectionViewDataSource {
    
    //MARK: - Displayer
    var displayer: SocialMediaDisplayer?
    
    //MARK: - Variables
    var user: UserModel?
    let cellIdentifier: String
    
    //MARK: - Setup
    init(cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
        super.init()
        
    }
    
    //MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayer?.numberOfItemDisplayers ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SocialMediaCell
        cell.displayer = displayer?.getItemDisplayer(for: indexPath)
        return cell
    }
    
}
