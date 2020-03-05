//
//  UploadTableViewController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import JGProgressHUD

class UploadTableViewController<T: UploadDisplayer>: TableViewController {
    
    //MARK: - Displayer
    var displayer: T? {
        didSet {
            setupBindablesFromDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    //MARK: - Views
    var progressHud: JGProgressHUD?
    
    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
    private func setupBindablesFromDisplayer() {
        
        displayer?.alert.asObservable().subscribe(onNext: { [weak self] (alert) in
            guard let alert = alert else { return }
            let alertController = UIAlertController(title: alert.alertHeader, message: alert.alertMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self?.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        
        displayer?.isLoading.asObservable().subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            if isLoading {
                let progressHud = JGProgressHUD(style: .dark)
                progressHud.textLabel.text = self.displayer?.progressHudMessage
                self.progressHud = progressHud
                self.progressHud?.show(in: self.view.window ?? self.view)
            } else {
                self.progressHud?.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
