//
//  CategoryFeedViewController.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift
import JGProgressHUD

class CategoryCollectionMasterViewController: ViewController {
    
    //MARK: - Displayer
    let displayer: CategoryCollectionMasterDisplayer
    
    //MARK: - Setup
    init(displayer: CategoryCollectionMasterDisplayer) {
        self.displayer = displayer
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindablesFromDisplayer()
    }
    
    //MARK: - Delegation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Views
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromDisplayer() {

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


