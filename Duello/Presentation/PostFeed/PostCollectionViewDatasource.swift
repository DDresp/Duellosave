//
//  PostCollectionViewDatasource.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit
import Firebase

class PostCollectionViewDatasource: NSObject, UICollectionViewDataSource {
    
    //MARK: - Displayer
    let displayer: FeedDisplayer
    
    //MARK: - Child Displayers
    var profileDisplayer: UserHeaderDisplayer? { return displayer.userHeaderDisplayer }
    var postsDisplayer: PostCollectionDisplayer { return displayer.postCollectionDisplayer }
    
    //MARK: - Variables
    let singleImageIdentifier: String
    let imagesIdentifier: String
    let videoIdentifier: String
    let headerIdentifier: String
    let footerIdentifier: String
    let emptyIdentifier: String
    
    //MARK: - Setup
    init(singleImageIdentifier: String, imagesIdentifier: String, videoIdentifier: String, headerIdentifier: String, footerIdentifier: String, emptyIdentifier: String, displayer: FeedDisplayer) {
        self.singleImageIdentifier = singleImageIdentifier
        self.imagesIdentifier = imagesIdentifier
        self.videoIdentifier = videoIdentifier
        self.headerIdentifier = headerIdentifier
        self.footerIdentifier = footerIdentifier
        self.emptyIdentifier = emptyIdentifier
        self.displayer = displayer
        super.init()
    }
    
    //MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !postsDisplayer.noPostsAvailable else { return 1 }
        return postsDisplayer.numberOfPostDisplayers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard !postsDisplayer.noPostsAvailable, let postDisplayer = postsDisplayer.getPostDisplayer(at: indexPath.item) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: emptyIdentifier, for: indexPath)
        }
        
        switch postDisplayer {
            
        case is SingleImagePostViewModel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: singleImageIdentifier, for: indexPath) as! SingleImagePostCell
            cell.displayer = postDisplayer as? SingleImagePostViewModel
            cell.configure()
            return cell
        case is ImagesPostViewModel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagesIdentifier, for: indexPath) as! ImagesPostCell
            cell.displayer = postDisplayer as? ImagesPostViewModel
            cell.configure()
            return cell
        case is VideoPostViewModel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoIdentifier, for: indexPath) as! VideoPostCell
            cell.displayer = postDisplayer as? VideoPostViewModel
            cell.configure()
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserHeader
            cell.displayer = profileDisplayer
            cell.configure()
            return cell
        } else if kind == UICollectionView.elementKindSectionFooter {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! FooterLoadingCell
            cell.displayer = postsDisplayer
            return cell
        }
        return UICollectionReusableView()
    }
    
}
