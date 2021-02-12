//
//  PostingController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ExploreCategoryPostingController: ViewController {
    
    //MARK: - ViewModel
    let viewModel: ExploreCategoryPostingViewModel
    
    //MARK: - Variables:
    private lazy var uploadImagesSection: Int? = {
        return viewModel.imagesAllowed ? 0 : nil
    }()
    
    private lazy var uploadVideoSection: Int? = {
        if viewModel.imagesAllowed && viewModel.videosAllowed {
            return 1
        } else if viewModel.videosAllowed {
            return 0
        } else {
            return nil
        }
    }()
    
    private lazy var numberOfSections: Int = max(uploadImagesSection ?? 0, uploadVideoSection ?? 0) + 1
    
    //MARK: - Setup
    init(viewModel: ExploreCategoryPostingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DARK_GRAY
        setupTableView()
        setupLayout()
        setupBindablesToViewModel()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        tv.isScrollEnabled = false
        tv.delegate = self
        tv.dataSource = self
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
        navigationItem.title = "Upload Post"
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToViewModel() {
        cancelButton.rx.tap.asDriver().drive(viewModel.cancelTapped).disposed(by: disposeBag)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - TableView Datasource
extension ExploreCategoryPostingController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = LIGHT_GRAY
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: SMALLFONTSIZE)
        cell.selectionStyle = .none
        cell.backgroundColor = BLACK
        cell.imageView?.tintColor = LIGHT_GRAY
        if indexPath.section == uploadImagesSection {

            switch indexPath.item {
            case 0:
                cell.textLabel?.text = "Upload images from library"
                cell.imageView?.image = #imageLiteral(resourceName: "photoIcon").withRenderingMode(.alwaysTemplate)
            case 1:
                cell.textLabel?.text = "Upload images from instagram"
                cell.imageView?.image = #imageLiteral(resourceName: "instagramIcon").withRenderingMode(.alwaysTemplate)
            default:
                ()
            }

        } else if indexPath.section == uploadVideoSection {

            switch indexPath.item {
            case 0:
                cell.textLabel?.text = "Upload video from library"
                cell.imageView?.image = #imageLiteral(resourceName: "videoIcon").withRenderingMode(.alwaysTemplate)
            case 1:
                cell.textLabel?.text = "Upload video from instagram"
                cell.imageView?.image = #imageLiteral(resourceName: "instagramIcon").withRenderingMode(.alwaysTemplate)
            default:
                ()
            }

        }
        return cell
    }
    
}

//MARK: - TableView Delegate
extension ExploreCategoryPostingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = SmallHeaderLabel()
        
        if section == uploadImagesSection {
            headerLabel.text = "IMAGES"
        } else if section == uploadVideoSection {
            headerLabel.text = "VIDEO"
        }
        
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == uploadImagesSection {
            
            switch indexPath.item {
            case 0:
                viewModel.uploadImageSelected.accept(())
            case 1:
                viewModel.uploadInstagramImageSelected.accept(())
            default:
                ()
            }
            
        } else if indexPath.section == uploadVideoSection {
            
            switch indexPath.item {
            case 0:
                viewModel.uploadVideoSelected.accept(())
            case 1:
                viewModel.uploadInstagramVideoSelected.accept(())
            default:
                ()
            }
        }
        
    }
    
}
