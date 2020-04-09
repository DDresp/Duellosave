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
    let displayer: PostCollectionDisplayer
    
    //MARK: - Child Displayers
    var profileDisplayer: PostHeaderDisplayer? { return displayer.postHeaderDisplayer }
    var postsDisplayer: PostListDisplayer { return displayer.postListDisplayer }
    
    //MARK: - Variables
    let singleImageIdentifier: String
    let imagesIdentifier: String
    let videoIdentifier: String
    let headerIdentifier: String
    let footerIdentifier: String
    let emptyIdentifier: String
    
    //MARK: - Setup
    init(singleImageIdentifier: String, imagesIdentifier: String, videoIdentifier: String, headerIdentifier: String, footerIdentifier: String, emptyIdentifier: String, displayer: PostCollectionDisplayer) {
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
        if displayer.hasNoPosts, displayer.allDataLoaded.value {
            return 1
        } else if displayer.hasNoPosts {
            return 0
        } else {
            return postsDisplayer.numberOfPostDisplayers
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard !displayer.hasNoPosts, let postDisplayer = postsDisplayer.getPostDisplayer(at: indexPath.item) else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyIdentifier, for: indexPath) as! EmptyCell
            cell.displayer = displayer
            return cell
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
            guard let headerDisplayer = displayer.postHeaderDisplayer else { return UICollectionViewCell() }
            
            switch headerDisplayer {
            case is UserHeaderViewModel:
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserHeader
                cell.displayer = headerDisplayer as? UserHeaderViewModel
                cell.configure()
                return cell
            case is CategoryHeaderViewModel:
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! CategoryHeader
                cell.displayer = headerDisplayer as? CategoryHeaderViewModel
                cell.configure()
                return cell
            default:
                return UICollectionViewCell()
            }
        } else if kind == UICollectionView.elementKindSectionFooter {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! FooterLoadingCell
            cell.displayer = displayer
            return cell
        }
        return UICollectionReusableView()
    }
    
}
