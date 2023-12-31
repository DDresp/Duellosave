//
//  PostCollectionViewDelegate.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
import RxSwift
import RxCocoa

class PostCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    //MARK: - Displayer
    let displayer: PostCollectionDisplayer

    //MARK: - Child Displayers
    var headerDisplayer: PostHeaderDisplayer? { return displayer.postHeaderDisplayer }
    var postListDisplayer: PostListDisplayer { return displayer.postListDisplayer }
    
    //MARK: - Variables
    weak var collectionView: UICollectionView?
    
    var squishedSizes = [Int: CGSize]()
    var expandedSizes = [Int: CGSize]()
    
    private lazy var userHeader = UserHeader(frame: .init(x: 0, y: 0, width: frameWidth, height: 1000))
    private lazy var categoryHeader = CategoryHeader(frame: .init(x: 0, y: 0, width: frameWidth, height: 1000))
    
    private lazy var singleImageCell = SingleImagePostCell(frame: .init(x: 0, y: 0, width: frameWidth, height: 1000))
    private lazy var imagesCell = ImagesPostCell(frame: .init(x: 0, y: 0, width: frameWidth, height: 1000))
    private lazy var videoCell = VideoPostCell(frame: .init(x: 0, y: 0, width: frameWidth, height: 1000))
    
    //MARK: - Setup
    init(displayer: PostCollectionDisplayer, collectionView: UICollectionView) {
        self.displayer = displayer
        self.collectionView = collectionView
        super.init()
    }

    //MARK: - Delegation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard let headerDisplayer = headerDisplayer else { return .zero}
        return estimateHeaderSize(for: headerDisplayer)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if displayer.hasNoPosts || displayer.allDataLoaded.value {
            return .zero
        }
        return .init(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let postDisplayer = postListDisplayer.getPostDisplayer(at: indexPath.item) else { return .init(width: frameWidth, height: 500) }

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
        postListDisplayer.didEndDisplayingCell.accept(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        postListDisplayer.willDisplayCell.accept(indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        displayer.collectionViewScrolled.accept(())
    }
    
    //MARK: - Getters
    private lazy var frameWidth: CGFloat = {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width
    }()
    
    
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
            print("displayer not known in cell sizing")
        }
        
        let size = cell.systemLayoutSizeFitting(.init(width: frameWidth, height: 1000))
        return .init(width: frameWidth, height: size.height)
    }
    
    private func estimateHeaderSize(for displayer: PostHeaderDisplayer) -> CGSize {
        
        switch displayer {
        case let viewModel as UserHeaderViewModel:
            userHeader.displayer = viewModel
            userHeader.fit()
            let size = userHeader.systemLayoutSizeFitting(.init(width: frameWidth, height: 1000))
            return .init(width: frameWidth, height: size.height)
        case let viewModel as CategoryHeaderViewModel:
            categoryHeader.displayer = viewModel
            categoryHeader.fit()
            let size = categoryHeader.systemLayoutSizeFitting(.init(width: frameWidth, height: 1000))
            return .init(width: frameWidth, height: size.height)
        default:
            return .init(width: 0, height: 0)
        }
        
    }
    
}
