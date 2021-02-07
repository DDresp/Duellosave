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
        
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        
        view.backgroundColor = .black
        setupNavigationItems()
        setupSearchController()
        setupCollectionView()
        setupBindablesToDisplayer()
    }
    
    //MARK: - Views
//    private let addCategoryButton = UIBarButtonItem(title: "add category", style: .plain, target: nil, action: nil)
    
    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BLACK
        return view
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.showsBookmarkButton = true
        sc.searchBar.setImage(#imageLiteral(resourceName: "addIcon").withRenderingMode(.alwaysTemplate), for: .bookmark, state: .normal)
        sc.searchBar.delegate = self
        
//        sc.searchBar.barTintColor = BLACK
//        sc.searchBar.backgroundColor = .clear
        //        sc.searchBar.barStyle = .blackOpaque
//        sc.searchBar.
//
//            UINavigationBar.appearance().tintColor = LIGHT_GRAY
//            UINavigationBar.appearance().barTintColor = BLACK
        return sc
    }()
    
    lazy var collectionView: CategoryCollectionView = {
        let collectionView = CategoryCollectionView(displayer: viewModel.categoryCollectionViewModel)
        return collectionView
    }()
    
    //MARK: - Layout
    private func setupNavigationItems() {
        
//        navigationItem.title = "Explore"
//        navigationItem.rightBarButtonItem = addCategoryButton
    }
    
    private func setupSearchController() {
        view.addSubview(searchContainer)
        searchContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .zero, size: .init(width: 0, height: 60))
        
        searchContainer.addSubview(searchController.searchBar)
    }
    
    private func setupCollectionView() {
        edgesForExtendedLayout = []
        
        view.addSubview(collectionView)
        collectionView.anchor(top: searchContainer.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: STANDARDSPACING, left: 0, bottom: 0, right: 0))
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()

    private func setupBindablesToDisplayer() {
//        addCategoryButton.rx.tap.asObservable().bind(to: viewModel.addCategoryTapped).disposed(by: disposeBag)
        
        searchController.searchBar.rx.bookmarkButtonClicked.bind(to: viewModel.addCategoryTapped).disposed(by: disposeBag)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ExploreController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("debug: button clicked")
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("debug: book clicked")
    }
    
}

