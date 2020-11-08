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
    let displayer: PostCollectionDisplayer
    
    //MARK: - Child Displayers
    var headerDisplayer: PostHeaderDisplayer? {
        return displayer.postHeaderDisplayer
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
    
    //MARK: - Setup
    init(displayer: PostCollectionDisplayer) {
        self.displayer = displayer
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = ULTRADARKCOLOR
        setup()
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
        displayer.needsRestart.accept(true)
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
        register(EmptyCell.self, forCellWithReuseIdentifier: emptyIdentifier) //Todo: Specific to Home??
        register(FooterLoadingCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        
        if displayer.hasHeader {
            let header = displayer.postHeaderDisplayer!
            switch header {
            case is UserHeaderViewModel:
                register(UserHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
            case is CategoryHeaderViewModel:
                register(CategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
            default:
                return ()
            }
        }
        
    }
    
    //MARK: - Views
    
    private let refreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        refreshControl?.rx.controlEvent(.valueChanged).bind(to: displayer.refreshChanged).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        
        displayer.reloadData.subscribe(onNext: { [weak self] (_) in
            self?.setContentOffset(.zero, animated: false)
            self?.feedDelegate.clearCache()

            if (self?.refreshControl?.isRefreshing == true) {
                self?.refreshControl?.endRefreshing()
            }

            self?.reloadData()
            self?.layoutIfNeeded()
            self?.displayer.uiLoaded.accept(true)
            
        }).disposed(by: disposeBag)
        
        displayer.insertData.subscribe(onNext: { [weak self] (startIndex, endIndex) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let indexPaths = Array(startIndex...endIndex).map { IndexPath(item: $0, section: 0) }
                self.insertItems(at: indexPaths)
            }
        }).disposed(by: disposeBag)
        
        displayer.updateLayout.subscribe(onNext: { [weak self] () in
            self?.performBatchUpdates({})
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
