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
        setupBindablesFromViewModel()
    }
    
    private func setupNavigationItems() {
        let label = UILabel()
        label.text = viewModel.category.getTitle()
        label.textColor = LIGHT_GRAY
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        navigationItem.titleView = label
        navigationItem.titleView?.isHidden = true
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    //MARK: - Views
//    let addContentButton = UIBarButtonItem(title: "Add Content  ", style: .plain, target: nil, action: nil)
    let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backIcon").withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    
    lazy var collectionView: PostCollectionView = {
        let collectionView = PostCollectionView(displayer: viewModel.postCollectionDisplayer)
        return collectionView
    }()
    
    //MARK: - Layout
    private func setupCollectionViewLayout() {
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
    }
    
    //MARK: - Delegation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToViewModel() {
        
//        addContentButton.rx.tap.map { (_) -> Void in
//            return ()
//            }.bind(to: viewModel.requestedAddContent).disposed(by: disposeBag)
//
        backButton.rx.tap.map { (_) -> Void in
            return ()
        }.bind(to: viewModel.goBack).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesFromViewModel() {
        viewModel.collectionViewScrolled.subscribe (onNext: { [weak self] (_) in
            guard let headerBottom = self?.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))?.rectCorrespondingToWindow.maxY else { return }
            guard let navBottom = self?.navigationController?.navigationBar.rectCorrespondingToWindow.maxY  else { return }
            
            if navBottom >= headerBottom {
                self?.navigationItem.titleView?.isHidden = false
            } else {
                self?.navigationItem.titleView?.isHidden = true
            }
            
        }).disposed(by: disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
