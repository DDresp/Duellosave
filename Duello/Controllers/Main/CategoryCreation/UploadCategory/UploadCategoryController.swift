//
//  UploadCategoryController.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadCategoryController: UploadTableViewController<UploadCategoryViewModel> {
    
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
    init(viewModel: UploadCategoryViewModel) {
        super.init(style: .plain)
        self.displayer = viewModel
        self.datasource = UploadCategoryDatasource(titleCellId: titleCellId, descriptionCellId: descriptionCellId, imageSelectorCellId: imagesSelectorCellId, videoSelectorCellId: videoSelectorCellId, displayer: viewModel, parentViewController: self)
        self.delegate = UploadCategoryDelegate(titleCellId: titleCellId, descriptionCellId: descriptionCellId, imageSelectorCellId: imagesSelectorCellId, videoSelectorCellId: videoSelectorCellId, displayer: viewModel)
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
        tableView.register(UploadPostImageSelectorCell.self, forCellReuseIdentifier: imagesSelectorCellId)
        tableView.register(UploadPostVideoSelectorCell.self, forCellReuseIdentifier: videoSelectorCellId)
        tableView.register(UploadPostDescriptionCell.self, forCellReuseIdentifier: descriptionCellId)
    }
    
    private func setupNavigationItems() {
        
        navigationItem.rightBarButtonItem = submitButton
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Category"
        navigationItem.rightBarButtonItem?.tintColor = NAVBARCOLOR
        
    }
    
    //MARK: - Views
    lazy var submitButton = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
    
    lazy var cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: nil)
    
    //MARK: - Interactions
    @objc func endEditing() {
        view.endEditing(true)
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
        cancelButton.rx.tap.asDriver().drive(displayer.cancelTapped).disposed(by: disposeBag)
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

