//
//  NewsController.swift
//  Duello
//
//  Created by Darius Dresp on 3/18/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
import RxCocoa
import RxSwift
import JGProgressHUD

class NewsController: PostFeedViewController {
    
    //MARK: - ViewModel
    let viewModel: HomeViewModel
    
    //MARK: - Setup
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(displayer: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupCollectionViewLayout()

    }
    
    private func setupNavigationItems() {
        navigationItem.title = "NewsFeed"
    }
    
    //MARK: - Views
    lazy var collectionView: PostCollectionView = {
        let collectionView = PostCollectionView(displayer: viewModel.homeCollectionViewModel)
        return collectionView
    }()
    
    
    //MARK: - Layout
    private func setupCollectionViewLayout() {
        //so that the scrollView doesn't get hidden under the navigationBar
        edgesForExtendedLayout = []
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
