//
//  CategoryProfileController.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ExploreCategoryProfileController: PostCollectionMasterViewController {
    
    //MARK: - ViewModels
    var viewModel: ExploreCategoryProfileViewModel {
        return displayer as! ExploreCategoryProfileViewModel
    }
    
    //MARK: - Setup
    init(viewModel: ExploreCategoryProfileViewModel) {
        super.init(displayer: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setupCollectionViewLayout()
        setupBindablesToViewModel()
    }
    
    private func setupNavigationItems() {
        navigationController?.navigationBar.tintColor = BLACK
        navigationItem.rightBarButtonItem = addContentButton
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    //MARK: - Views
    let addContentButton = UIBarButtonItem(title: "Add Content  ", style: .plain, target: nil, action: nil)
    let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
    
    lazy var collectionView: PostCollectionView = {
        let collectionView = PostCollectionView(displayer: viewModel.postCollectionDisplayer)
        return collectionView
    }()
    
    //MARK: - Layout
    private func setupCollectionViewLayout() {
        //so that the scrollView doesn't get hidden under the navigationBar
        edgesForExtendedLayout = []
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToViewModel() {
        
        addContentButton.rx.tap.map { (_) -> Void in
            return ()
            }.bind(to: viewModel.requestedAddContent).disposed(by: disposeBag)
        
        backButton.rx.tap.map { (_) -> Void in
            return ()
        }.bind(to: viewModel.goBack).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
