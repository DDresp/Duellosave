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
            setupBindablesToDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable floating headers
        let dummyViewHeight = CGFloat(40)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: dummyViewHeight))
        tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)

        
        tableView.backgroundColor = EXTREMELIGHTGRAYCOLOR
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        setupNavigationItems()
        
    }
    
    private func setupNavigationItems() {
        
        navigationItem.rightBarButtonItem = submitButton
        if displayer?.cancelTapped != nil {
            navigationItem.leftBarButtonItem = cancelButton
        }
        navigationItem.rightBarButtonItem?.tintColor = NAVBARBUTTONCOLOR
        
    }
    
    //MARK: - Views
    var progressHud: JGProgressHUD?
    
    lazy var submitButton = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
    lazy var cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: nil)
    
    //MARK: - Interactions
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    //MARK: - Methods
    func resizeTextCell(with textView: UITextView) {
        
        let startHeight = textView.frame.size.height
        let calcHeight = textView.sizeThatFits(textView.frame.size).height  //iOS 8+ only
        
        if startHeight != calcHeight {
            
            UIView.setAnimationsEnabled(false) // Disable animations
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
    private func setupBindablesFromDisplayer() {
        
        displayer?.alert.subscribe(onNext: { [weak self] (alert) in
            guard let alert = alert else { return }
            let alertController = UIAlertController(title: alert.alertHeader, message: alert.alertMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self?.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        
        displayer?.isLoading.subscribe(onNext: { [weak self] (isLoading) in
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
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        submitButton.rx.tap.asDriver().drive(displayer.submitTapped).disposed(by: disposeBag)
       
        guard let cancelTapped = displayer.cancelTapped else { return }
        cancelButton.rx.tap.asDriver().drive(cancelTapped).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
