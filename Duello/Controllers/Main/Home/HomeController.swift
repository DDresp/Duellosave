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

class HomeController: PostCollectionMasterViewController {
    
    //MARK: - ViewModel
    var viewModel: HomeViewModel {
        return displayer as! HomeViewModel
    }
    
    //MARK: - Setup
    init(viewModel: HomeViewModel) {
        super.init(displayer: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupNavigationItems()
        setupCollectionViewLayout()
        setupBindablesToDisplayer()
    }
    
//    private func setupNavigationItems() {
//        navigationItem.title = "Home"
//        navigationItem.leftBarButtonItem = logoutButton
//        navigationItem.rightBarButtonItem = settingsButton
//        navigationItem.rightBarButtonItem?.tintColor = NAVBARBUTTONCOLOR
//    }
    
    //MARK: - Views
    let logoutButton = UIBarButtonItem(title: "logout", style: .plain, target: nil, action: nil)
    let settingsButton = UIBarButtonItem(title: "settings", style: .plain, target: nil, action: nil)
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.white
        return button
    }()
    
    lazy var collectionView: PostCollectionView = {
        let collectionView = PostCollectionView(displayer: viewModel.homeCollectionViewModel)
        return collectionView
    }()
    
    //MARK: - Layout
    private func setupCollectionViewLayout() {
        //so that the scrollView doesn't get hidden under the navigationBar
        edgesForExtendedLayout = []
        
        view.addSubview(editButton)
        editButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: STANDARDSPACING, bottom: 0, right: 0), size: .init(width: 30, height: 25))
        
        view.addSubview(collectionView)
        collectionView.anchor(top: editButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: STANDARDSPACING, left: 0, bottom: 0, right: 0))
//        collectionView.fillSuperview()
        
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()

    private func setupBindablesToDisplayer() {
        logoutButton.rx.tap.asObservable().bind(to: viewModel.logoutTapped).disposed(by: disposeBag)
        settingsButton.rx.tap.asObservable().bind(to: viewModel.settingsTapped).disposed(by: disposeBag)
        editButton.rx.tap.asObservable().bind(to: viewModel.editingTapped).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
