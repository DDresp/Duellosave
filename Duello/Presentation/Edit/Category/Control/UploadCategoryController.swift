//
//  UploadCategoryController.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadCategoryController<T: UploadCategoryDisplayer>: UploadTableViewController<T>, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Variables
    var datasource: UploadCategoryDatasource?
    var delegate: UploadCategoryDelegate?
    
    private let coverImageCellId = "CoverImageCellId"
    private let titleCellId = "titleCellId"
    private let imagesSelectorCellId = "imagesSelectorId"
    private let videoSelectorCellId = "videoSelectorId"
    private let descriptionCellId = "descriptionCellId"
    
    private let imageCellSection = 0
    private let titleCellSection = 1
    private let selectorCellSection = 2
    private let descriptionCellSection = 3
    
    //MARK: - Setup
    init(displayer: T) {
        super.init(style: .plain)
        self.displayer = displayer
        self.datasource = UploadCategoryDatasource(coverImageCellId: coverImageCellId, titleCellId: titleCellId, descriptionCellId: descriptionCellId, imageSelectorCellId: imagesSelectorCellId, videoSelectorCellId: videoSelectorCellId, displayer: displayer, parentViewController: self)
        self.delegate = UploadCategoryDelegate(coverImageCellId: coverImageCellId, titleCellId: titleCellId, descriptionCellId: descriptionCellId, imageSelectorCellId: imagesSelectorCellId, videoSelectorCellId: videoSelectorCellId, displayer: displayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = datasource
        tableView.delegate = delegate
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        registerCells()
        setupBindablesFromDisplayer()
        
        navigationItem.title = "Category"
    }
    
    private func registerCells() {
        tableView.register(UploadCategoryImageCell.self, forCellReuseIdentifier: coverImageCellId)
        tableView.register(UploadTitleCell.self, forCellReuseIdentifier: titleCellId)
        tableView.register(UploadImagesSelectorCell.self, forCellReuseIdentifier: imagesSelectorCellId)
        tableView.register(UploadVideoSelectorCell.self, forCellReuseIdentifier: videoSelectorCellId)
        tableView.register(UploadDescriptionCell.self, forCellReuseIdentifier: descriptionCellId)
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

