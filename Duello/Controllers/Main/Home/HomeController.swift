//
//  HomeController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//TODO: fix likeView Animation in header ??
//TODO: fix settings button + imageButton tap ??
//TODO: fix size with/without socialMediaItems ??

import RxCocoa
import RxSwift
import JGProgressHUD

class HomeController: ViewController {
    
    //MARK: - ViewModel
    let viewModel: HomeViewModel
    
    //MARK: - Setup
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupCollectionViewLayout()
        
        setupBindablesFromOwnProperties()
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
        
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
    private let refreshControl = UIRefreshControl()
    
    lazy var collectionView: PostCollectionView = {
        let collectionView = PostCollectionView(displayer: viewModel)
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    var progressHud: JGProgressHUD?
    
    //MARK: - Layout
    private func setupCollectionViewLayout() {
        //so that the scrollView doesn't get hidden under the navigationBar
        edgesForExtendedLayout = []
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    //MARK: - Methods
    private func open(urlString: String?) {
        guard let link = urlString else { return }
        guard let url = URL(string: link) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        collectionView.refreshControl?.rx.controlEvent(.valueChanged).bind(to: viewModel.refreshChanged).disposed(by: disposeBag)
    }

    private func setupBindablesToDisplayer() {
        logoutButton.rx.tap.asObservable().bind(to: viewModel.logoutTapped).disposed(by: disposeBag)
        settingsButton.rx.tap.asObservable().bind(to: viewModel.settingsTapped).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        
        viewModel.showAlert.asObservable().subscribe(onNext: { [weak self] (alert) in
            let alertController = UIAlertController(title: alert.alertHeader, message: alert.alertMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self?.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.showActionSheet.asObservable().subscribe(onNext: { [weak self] (actionSheet) in
            
            let actionController = UIAlertController(title: actionSheet.actionHeader, message: actionSheet.actionMessage, preferredStyle: .actionSheet)
            
            for action in actionSheet.actions {
                let alertAction = UIAlertAction(title: action.title, style: .default, handler: { (_) in
                    if let warning = action.actionWarning {
                        let alertController = UIAlertController(title: warning.title, message: warning.message, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            action.handler?()
                        })
                        alertController.addAction(okAction)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alertController.addAction(cancelAction)
                        self?.present(alertController, animated: true)
                        
                    } else {
                        action.handler?()
                    }
                })
                actionController.addAction(alertAction)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            actionController.addAction(cancelAction)
            
            self?.present(actionController, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
        viewModel.showLoading.asObservable().subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            if isLoading {
                let progressHud = JGProgressHUD(style: .dark)
                self.progressHud = progressHud
                self.progressHud?.show(in: self.view.window ?? self.view)
            } else {
                self.progressHud?.dismiss()
            }
        }).disposed(by: disposeBag)
        
        viewModel.reloadData.asObservable().subscribe(onNext: { [weak self] (_) in
            if (self?.collectionView.refreshControl?.isRefreshing == true) {
                self?.collectionView.refreshControl?.endRefreshing()
            }
            self?.collectionView.reloadData()
            
        }).disposed(by: disposeBag)
        
        viewModel.restart.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.collectionView.restart()
        }).disposed(by: disposeBag)
        
        viewModel.loadLink.asObservable().subscribe(onNext: { [weak self] (link) in
            self?.open(urlString: link)
        }).disposed(by: disposeBag)
        
        viewModel.showAdditionalLinkAlert.asObservable().subscribe(onNext: { [weak self] (link) in
            self?.presentTwoButtonAlert(header: "Open Link?", message: "Do you want to open the link: \(link)", firstButtonTitle: "YES", secondButtonTitle: "NO", firstButtonAction: {
                self?.open(urlString: link)
            }, secondButtonAction: nil)
        }).disposed(by: disposeBag)
        
        viewModel.updateLayout.subscribe(onNext: { [weak self] (shouldExpand) in
            if shouldExpand {
                self?.collectionView.performBatchUpdates({})
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
