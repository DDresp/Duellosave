//
//  PostCollectionView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

class PostCollectionView: UICollectionView {
    
    //MARK: - Displayer
    let displayer: FeedDisplayer
    
    //MARK: - Variables
    lazy var feedDatasource = PostCollectionViewDatasource(singleImageIdentifier: singleImageIdentifier, imagesIdentifier: imagesIdentifier, videoIdentifier: videoIdentifier, headerIdentifier: headerIdentifier, footerIdentifier: footerIdentifier, emptyIdentifier: emptyIdentifier, displayer: displayer)
    lazy var feedPrefetchDatasource = PostCollectionViewPrefetchingDatasource(displayer: displayer)
    lazy var feedDelegate = PostCollectionViewDelegate(displayer: displayer, collectionView: self)
    
    let headerIdentifier = "header"
    let singleImageIdentifier = "singleImageCell"
    let imagesIdentifier = "imagesCell"
    let videoIdentifier = "videoCell"
    let footerIdentifier = "footer"
    let emptyIdentifier = "empty"
    
    //MARK: - Setup
    init(displayer: FeedDisplayer) {
        self.displayer = displayer
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = VERYLIGHTGRAYCOLOR
        setup()
    }
    
    private func setup() {
        
        contentInsetAdjustmentBehavior = .never
        
        dataSource = feedDatasource
        prefetchDataSource = feedPrefetchDatasource
        delegate = feedDelegate
        
        register(SingleImagePostCell.self, forCellWithReuseIdentifier: singleImageIdentifier)
        register(ImagesPostCell.self, forCellWithReuseIdentifier: imagesIdentifier)
        register(VideoPostCell.self, forCellWithReuseIdentifier: videoIdentifier)
        register(EmptyCell.self, forCellWithReuseIdentifier: emptyIdentifier)
        register(FooterLoadingCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        
        if displayer.hasProfileHeader {
            register(UserHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        }
        
    }
    
    //MARK: - Methods
    func restart() {
        feedDelegate.clearCache()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
