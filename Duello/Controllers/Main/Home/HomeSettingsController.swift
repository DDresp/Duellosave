//
//  HomeSettingsController.swift
//  Duello
//
//  Created by Darius Dresp on 1/16/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class HomeSettingsController: UIViewController {
    
    //MARK: - ViewModel
    private let viewModel: HomeSettingsViewModel
    
    //MARK: - Setup
    init(viewModel: HomeSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
    
        setupLayout()
        setupBindablesToViewModel()
    }
    
    //MARK: - Views
    lazy var cancelButton: UIBarButtonItem = {
        let image = #imageLiteral(resourceName: "cancelIcon").withRenderingMode(.alwaysTemplate)
        let button = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = BLACK
        tv.separatorColor = .clear
        tv.delegate = self
        return tv
    }()
    
    //MARK: - Layout
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupLayout() {
        layoutNavigationItems()
    
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    private func layoutNavigationItems() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Settings"
    }


    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
    private func setupBindablesToViewModel() {
        cancelButton.rx.tap.asDriver().drive(viewModel.cancelTapped).disposed(by: disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - TableView Datasource
extension HomeSettingsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.disclosureItems.count
        } else if section == 1 {
            return viewModel.standardItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = LIGHT_GRAY
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: SMALLFONTSIZE)
        cell.selectionStyle = .none
        cell.backgroundColor = BLACK
        
        if indexPath.section == 0 {
            cell.textLabel?.text = viewModel.disclosureItems[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            let image = #imageLiteral(resourceName: "disclosureIcon").withRenderingMode(.alwaysTemplate)
            let iv = UIImageView(image: image)
            iv.tintColor = LIGHT_GRAY
            cell.accessoryView = iv
            
        } else if indexPath.section == 1 {
            cell.textLabel?.text = viewModel.standardItems[indexPath.row]
        }

        return cell
    }
    
}

//MARK: - TableView Delegate
extension HomeSettingsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.disclosureItemTapped.onNext(indexPath.row)
        } else if indexPath.section == 1 {
            viewModel.standardItemTapped.onNext(indexPath.row)
        }
    }
    
}
