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
    
    //MARK: - Child Displayers
    var headerDisplayer: UserHeaderDisplayer? {
        return displayer.userHeaderDisplayer
    }
    
    var postListDisplayer: PostListDisplayer  {
        return displayer.postListDisplayer
    }

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
    
    private let refreshController = UIRefreshControl()
    
    //MARK: - Setup
    init(displayer: FeedDisplayer) {
        self.displayer = displayer
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = VERYLIGHTGRAYCOLOR
        setup()
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
        displayer.startFetching()
    }
    
    private func setup() {
        
        contentInsetAdjustmentBehavior = .never
        
        refreshControl = refreshController
        
        dataSource = feedDatasource
        prefetchDataSource = feedPrefetchDatasource
        delegate = feedDelegate
        
        register(SingleImagePostCell.self, forCellWithReuseIdentifier: singleImageIdentifier)
        register(ImagesPostCell.self, forCellWithReuseIdentifier: imagesIdentifier)
        register(VideoPostCell.self, forCellWithReuseIdentifier: videoIdentifier)
        register(EmptyCell.self, forCellWithReuseIdentifier: emptyIdentifier) //Specific to Home??
        register(FooterLoadingCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        
        if displayer.hasProfileHeader {
            register(UserHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        }
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        refreshControl?.rx.controlEvent(.valueChanged).bind(to: postListDisplayer.refreshChanged).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        
        postListDisplayer.restartData.subscribe(onNext: { [weak self] (_) in
        
            self?.setContentOffset(.zero, animated: false)
            self?.feedDelegate.clearCache()
            
            if (self?.refreshControl?.isRefreshing == true) {
                self?.refreshControl?.endRefreshing()
            }
            
            self?.reloadData()
            self?.layoutIfNeeded()
            self?.postListDisplayer.finishedStart.accept(true)
            
        }).disposed(by: disposeBag)
        
        postListDisplayer.reloadData.subscribe(onNext: { [weak self] (_) in
            self?.reloadData()
        }).disposed(by: disposeBag)
        
        postListDisplayer.updateLayout.subscribe(onNext: { [weak self] () in
            self?.performBatchUpdates({})
        }).disposed(by: disposeBag)
        
        guard let userHeaderDisplayer = headerDisplayer else { return }
        
        userHeaderDisplayer.reload.subscribe(onNext: { [weak self] (_) in
            self?.collectionViewLayout.invalidateLayout()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
