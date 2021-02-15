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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        registerCells()
        setupBindablesFromDisplayer()
        
        navigationItem.title = "Post"
        
    }
    
    private func registerCells() {
        tableView.register(UploadTitleCell.self, forCellReuseIdentifier: titleCellId)
        tableView.register(UploadDescriptionCell.self, forCellReuseIdentifier: descriptionCellId)
        
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
    
    //MARK: - Interactions
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        displayer?.didDisappear.accept(())
    }
    
    //MARK: - Reactive
    private func setupBindablesFromDisplayer() {
        displayer?.descriptionDisplayer.description.asDriver().drive(onNext: { [weak self] (description) in
            guard let self = self, let desc = description, desc.count > 0 else { return }
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            let thisIndexPath = IndexPath(row: 0, section: self.descriptionCellSection)
            self.tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false) //Otherwise the scrolling (when text enters new line) is invoked late
            
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
