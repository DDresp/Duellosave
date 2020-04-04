//
//  UploadCategoryController.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadCategoryController<T: UploadCategoryDisplayer>: UploadTableViewController<T> {
    
    //MARK: - Variables
    var datasource: UploadCategoryDatasource?
    var delegate: UploadCategoryDelegate?
    
    private let titleCellId = "titleCellId"
    private let imagesSelectorCellId = "imagesSelectorId"
    private let videoSelectorCellId = "videoSelectorId"
    private let descriptionCellId = "descriptionCellId"
    
    private let titleCellSection = 0
    private let selectorCellSection = 1
    private let descriptionCellSection = 2
    
    //MARK: - Setup
    init(displayer: T) {
        super.init(style: .plain)
        self.displayer = displayer
        self.datasource = UploadCategoryDatasource(titleCellId: titleCellId, descriptionCellId: descriptionCellId, imageSelectorCellId: imagesSelectorCellId, videoSelectorCellId: videoSelectorCellId, displayer: displayer, parentViewController: self)
        self.delegate = UploadCategoryDelegate(titleCellId: titleCellId, descriptionCellId: descriptionCellId, imageSelectorCellId: imagesSelectorCellId, videoSelectorCellId: videoSelectorCellId, displayer: displayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = datasource
        tableView.delegate = delegate
        
        registerCells()
        setupBindablesFromDisplayer()
        
        navigationItem.title = "Category"
    }
    
    private func registerCells() {
        tableView.register(UploadTitleCell.self, forCellReuseIdentifier: titleCellId)
        tableView.register(UploadImagesSelectorCell.self, forCellReuseIdentifier: imagesSelectorCellId)
        tableView.register(UploadVideoSelectorCell.self, forCellReuseIdentifier: videoSelectorCellId)
        tableView.register(UploadDescriptionCell.self, forCellReuseIdentifier: descriptionCellId)
    }
    
    //MARK: - Reactive
    private func setupBindablesFromDisplayer() {
        displayer?.descriptionDisplayer.description.asDriver().drive(onNext: { [weak self] (description) in
            guard let self = self else { return }
            let indexPath = IndexPath(row: 0, section: self.descriptionCellSection)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? UploadDescriptionCell else { return }
            let textView = cell.textView
            self.resizeTextCell(with: textView)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

