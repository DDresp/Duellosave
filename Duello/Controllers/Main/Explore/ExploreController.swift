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
        setupBindablesToDisplayer()
    }
    
    private func setupNavigationItems() {
        navigationItem.title = "Explore"
        navigationItem.rightBarButtonItem = addCategoryButton
    }
    
    //MARK: - Views
    
    let addCategoryButton = UIBarButtonItem(title: "add category", style: .plain, target: nil, action: nil)
    
    lazy var collectionView: CategoryCollectionView = {
        let collectionView = CategoryCollectionView(displayer: viewModel.categoryCollectionViewModel)
        return collectionView
    }()
    
    private func setupCollectionView() {
        edgesForExtendedLayout = []
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()

    private func setupBindablesToDisplayer() {
        addCategoryButton.rx.tap.asObservable().bind(to: viewModel.addCategoryTapped).disposed(by: disposeBag)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

