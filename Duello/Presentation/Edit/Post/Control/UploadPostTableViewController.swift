//
//  UploadPostTableViewController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import JGProgressHUD

class UploadPostTableViewController<T: UploadPostDisplayer>: UploadTableViewController<T> {
    
    //MARK: - Variables
    var datasource: UploadPostDatasource?
    var delegate: UploadPostDelegate?
    
    private let mediaCellId = "mediaCellId"
    private let titleCellId = "titleCellId"
    private let descriptionCellId = "descriptionCellId"
    
    private let mediaCellSection = 0
    private let titleCellSection = 1
    private let descriptionCellSection = 2
    
    //MARK: - Setup
    init(displayer: T) {
        super.init(style: .plain)
        self.displayer = displayer
        self.datasource = UploadPostDatasource(mediaCellId: mediaCellId, titleCellId: titleCellId, descriptionCellId: descriptionCellId, displayer: displayer, parentViewController: self)
        self.delegate = UploadPostDelegate(mediaCellId: mediaCellId, titleCellId: titleCellId, descriptionCellId: descriptionCellId, displayer: displayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = datasource
        tableView.delegate = delegate
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        setupTableView()
        setupNavigationItems()
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
        
    }
    
    private func setupTableView() {
        tableView.backgroundColor = EXTREMELIGHTGRAYCOLOR
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.register(UploadPostTitleCell.self, forCellReuseIdentifier: titleCellId)
        tableView.register(UploadPostDescriptionCell.self, forCellReuseIdentifier: descriptionCellId)
        
        guard let displayer = displayer else { return }
        
        switch displayer {
        case is UploadSingleImagePostDisplayer:
            tableView.register(UploadSingleImageMediaPostCell.self, forCellReuseIdentifier: mediaCellId)
        case is UploadImagesPostDisplayer:
            tableView.register(UploadImagesMediaPostCell.self, forCellReuseIdentifier: mediaCellId)
        case is UploadVideoPostDisplayer:
            tableView.register(UploadVideoMediaPostCell.self, forCellReuseIdentifier: mediaCellId)
        default:
            ()
        }
    }
    
    private func setupNavigationItems() {
        
        navigationItem.rightBarButtonItem = submitButton
        navigationItem.title = "Post"
        navigationItem.rightBarButtonItem?.tintColor = NAVBARCOLOR
        
    }
    
    //MARK: - Views
    lazy var submitButton = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
    
    //MARK: - Interactions
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayer?.willDisappear.accept(())
    }
    
    //MARK: - Methods
    private func resizeDecriptionCell(with text: String?) {
        let indexPath = IndexPath(row: 0, section: descriptionCellSection)
        guard let cell = tableView.cellForRow(at: indexPath) as? UploadPostDescriptionCell else { return }
        let textView = cell.textView
        
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
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        submitButton.rx.tap.asDriver().drive(displayer.submitTapped).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        displayer?.descriptionDisplayer.description.asDriver().drive(onNext: { [weak self] (description) in
            self?.resizeDecriptionCell(with: description)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
