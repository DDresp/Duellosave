//
//  PostCollectionViewDelegate.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class PostCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Displayer
    let displayer: FeedDisplayer

    var profileDisplayer: UserHeaderDisplayer? { return displayer.userHeaderDisplayer }
    var postsDisplayer: PostCollectionDisplayer { return displayer.postCollectionDisplayer }
    
    //MARK: - Variables
    let collectionView: UICollectionView
    
    var squishedSizes = [Int: CGSize]()
    var expandedSizes = [Int: CGSize]()
    
    private lazy var profileHeader = UserHeader(frame: .init(x: 0, y: 0, width: collectionView.frame.width, height: 1000))
    private lazy var singleImageCell = SingleImagePostCell(frame: .init(x: 0, y: 0, width: collectionView.frame.width, height: 1000))
    private lazy var imagesCell = ImagesPostCell(frame: .init(x: 0, y: 0, width: collectionView.frame.width, height: 1000))
    private lazy var videoCell = VideoPostCell(frame: .init(x: 0, y: 0, width: collectionView.frame.width, height: 1000))
    
    //MARK: - Setup
    init(displayer: FeedDisplayer, collectionView: UICollectionView) {
        self.displayer = displayer
        self.collectionView = collectionView
        super.init()
    }

    //MARK: - Delegation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard let headerDisplayer = profileDisplayer else { return .zero}
        return estimateHeaderSize(for: headerDisplayer)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard !postsDisplayer.noPostsAvailable else { return .init(width: collectionView.frame.width, height: 300)}
        guard let postDisplayer = postsDisplayer.getPostDisplayer(at: indexPath.item) else { return .init(width: 0, height: 0) }
        
        if postDisplayer.didExpand.value {
            if let size = expandedSizes[indexPath.item] { return size }
            let newSize = estimateCellSize(for: postDisplayer)
            expandedSizes[indexPath.item] = newSize
            return newSize
        } else {
            if let size = squishedSizes[indexPath.item] { return size }
            let newSize = estimateCellSize(for: postDisplayer)
            squishedSizes[indexPath.item] = newSize
            return newSize
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        postsDisplayer.didEndDisplayingCell.accept(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        postsDisplayer.willDisplayCell.accept(indexPath.row)
    }
    
    
    //MARK: - Methods
    
    func clearCache() {
        self.squishedSizes = [Int: CGSize]()
        self.expandedSizes = [Int: CGSize]()
    }
    
    private func estimateCellSize(for displayer: PostDisplayer) -> CGSize {
        
        var cell = UICollectionViewCell()
        
        switch displayer {
            
        case let displayer as SingleImagePostViewModel:
            singleImageCell.displayer = displayer
            singleImageCell.fit()
            cell = singleImageCell
        case let displayer as ImagesPostViewModel:
            imagesCell.displayer = displayer
            imagesCell.fit()
            cell = imagesCell
        case let displayer as VideoPostViewModel:
            videoCell.displayer = displayer
            videoCell.fit()
            cell = videoCell
        default:
            print("developing: displayer not known in cell sizing")
        }
        
        let size = cell.systemLayoutSizeFitting(.init(width: collectionView.frame.width, height: 1000))
        return .init(width: collectionView.frame.width, height: size.height)
    }
    
    private func estimateHeaderSize(for displayer: UserHeaderDisplayer) -> CGSize {
        
        profileHeader.displayer = displayer
        profileHeader.fit()
        let size = profileHeader.systemLayoutSizeFitting(.init(width: collectionView.frame.width, height: 1000))
        return .init(width: collectionView.frame.width, height: size.height)
        
    }
    
}
