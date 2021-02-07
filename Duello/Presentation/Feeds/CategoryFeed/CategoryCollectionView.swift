//
//  CategoryCollectionView.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

class CategoryCollectionView: UICollectionView {
    
    //MARK: - Displayer
    let displayer: CategoryCollectionDisplayer

    //MARK: - Variables
    lazy var feedDatasource = CategoryCollectionViewDatasource(categoryIdentifier: categoryIdentifier, footerIdentifier: footerIdentifier, displayer: displayer)
    lazy var feedDelegate = CategoryCollectionViewDelegate(displayer: displayer, collectionView: self)
    lazy var feedPrefetchDatasource = CategoryCollectionViewPrefetchingDatasource(displayer: displayer)
    
    let categoryIdentifier = "categoryCell"
    let footerIdentifier = "footer"
    
    //MARK: - Setup
    init(displayer: CategoryCollectionDisplayer) {
        self.displayer = displayer
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = BLACK
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
        register(CategoryCell.self, forCellWithReuseIdentifier: categoryIdentifier)
        register(FooterLoadingCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        
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
            if (self?.refreshControl?.isRefreshing == true) {
                self?.refreshControl?.endRefreshing()
            }
            self?.reloadData()
            self?.layoutIfNeeded()
        }).disposed(by: disposeBag)
        
        displayer.insertData.subscribe(onNext: { [weak self] (startIndex, endIndex) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let indexPaths = Array(startIndex...endIndex).map { IndexPath(item: $0, section: 0) }
                self.insertItems(at: indexPaths)
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

