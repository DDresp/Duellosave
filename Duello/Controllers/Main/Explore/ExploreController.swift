//
//  ExploreController.swift
//  Duello
//
//  Created by Darius Dresp on 4/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class ExploreController: CategoryCollectionMasterViewController {
    
    //MARK: - ViewModels
    var viewModel: ExploreViewModel {
        return displayer as! ExploreViewModel
    }
    
    //MARK: - Setup
    init(viewModel: ExploreViewModel) {
        super.init(displayer: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        setupNavigationItems()
        setupCollectionView()
    }
    
    private func setupNavigationItems() {
        navigationItem.title = "Explore"
    }
    
    //MARK: - Views
    lazy var collectionView: CategoryCollectionView = {
        let collectionView = CategoryCollectionView(displayer: viewModel.categoriesViewModel)
        return collectionView
    }()
    
    private func setupCollectionView() {
        edgesForExtendedLayout = []
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

