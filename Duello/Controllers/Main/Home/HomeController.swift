//
//  HomeController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift
import JGProgressHUD

class HomeController: PostFeedViewController {
    
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
        setupBindablesToDisplayer()
    }
    
    private func setupNavigationItems() {
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem?.tintColor = NAVBARCOLOR
    }
    
    //MARK: - Views
    let logoutButton = UIBarButtonItem(title: "logout", style: .plain, target: nil, action: nil)
    let settingsButton = UIBarButtonItem(title: "settings", style: .plain, target: nil, action: nil)
    
    lazy var collectionView: PostCollectionView = {
        let collectionView = PostCollectionView(displayer: viewModel)
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

    private func setupBindablesToDisplayer() {
        logoutButton.rx.tap.asObservable().bind(to: viewModel.logoutTapped).disposed(by: disposeBag)
        settingsButton.rx.tap.asObservable().bind(to: viewModel.settingsTapped).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("debug: deinit HomeController")
    }
}
