//
//  PostFeedViewController.swift
//  Duello
//
//  Created by Darius Dresp on 3/6/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift
import JGProgressHUD

class PostFeedViewController: ViewController {
    
    //MARK: - Displayer
    let displayer: FeedDisplayer
    
    //MARK: - Setup
    init(displayer: FeedDisplayer) {
        self.displayer = displayer
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindablesFromDisplayer()
        
    }
    
    //MARK: - Views
    var progressHud: JGProgressHUD?
    
    //MARK: - Delegation
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayer.viewIsAppeared.accept(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        displayer.viewIsAppeared.accept(false)
    }
    
    //MARK: - Methods
    private func open(urlString: String?) {
        guard let link = urlString else { return }
        guard let url = URL(string: link) else { return }
        displayer.viewIsAppeared.accept(false)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromDisplayer() {
        
        displayer.showAlert.asObservable().subscribe(onNext: { [weak self] (alert) in
            let alertController = UIAlertController(title: alert.alertHeader, message: alert.alertMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self?.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        
        displayer.showActionSheet.asObservable().subscribe(onNext: { [weak self] (actionSheet) in
            
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
        
        displayer.showLoading.asObservable().subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            if isLoading {
                let progressHud = JGProgressHUD(style: .dark)
                self.progressHud = progressHud
                self.progressHud?.show(in: self.view.window ?? self.view)
            } else {
                self.progressHud?.dismiss()
            }
        }).disposed(by: disposeBag)
        
        displayer.loadLink.asObservable().subscribe(onNext: { [weak self] (link) in
            self?.open(urlString: link)
        }).disposed(by: disposeBag)
        
        displayer.showAdditionalLinkAlert.asObservable().subscribe(onNext: { [weak self] (link) in
            self?.presentTwoButtonAlert(header: "Open Link?", message: "Do you want to open the link: \(link)", firstButtonTitle: "YES", secondButtonTitle: "NO", firstButtonAction: {
                self?.open(urlString: link)
            }, secondButtonAction: nil)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

