//
//  CategoryProfileController.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import SDWebImage

class ExploreCategoryProfileController: PostCollectionMasterViewController {
    
    //MARK: - ViewModels
    var viewModel: ExploreCategoryProfileViewModel {
        return displayer as! ExploreCategoryProfileViewModel
    }
    
    //MARK: - Setup
    init(viewModel: ExploreCategoryProfileViewModel) {
        super.init(displayer: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupCollectionViewLayout()
        setupBottomControl()
        
        setupBindablesToViewModel()
        setupBindablesFromViewModel()
    }
    
    private func setupNavigationItems() {
        let label = UILabel()
        label.text = viewModel.category.getTitle()
        label.textColor = LIGHT_GRAY
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        navigationItem.titleView = label
        navigationItem.titleView?.isHidden = true
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItems = [ellipsisButton, addContentButton]
    }
    
    //MARK: - Views
    let addContentButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addIcon").withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    let ellipsisButton = UIBarButtonItem(image: UIImage(named: "ellipsisIcon")?.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    
    let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backIcon").withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    
    lazy var collectionView: PostCollectionView = {
        let collectionView = PostCollectionView(displayer: viewModel.postCollectionDisplayer)
        return collectionView
    }()
    
    lazy var bottomImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    private let bottomTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        label.textColor = LIGHT_GRAY
        return label
    }()
    
    private let bottomInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: EXTREMESMALLFONTSIZE)
        label.textColor = LIGHT_GRAY
        label.text = "Rate whose content is the best"
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.setTitleColor(LIGHT_GRAY, for: .normal)
        button.backgroundColor = GRAY
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return button
    }()
    
    private let bottomControlView: UIView = {
        let view = UIView()
        view.backgroundColor = GRAY
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var bottomLabelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [bottomTitleLabel, bottomInfoLabel])
        sv.spacing = 5
        sv.axis = .vertical
        return sv
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [bottomImageView, bottomLabelStackView, startButton])
        sv.spacing = STANDARDSPACING
        sv.alignment = .center
        return sv
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return blurView
    }()
    
    //MARK: - Layout
    private func setupCollectionViewLayout() {
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)

    }
    
    private func setupBottomControl() {
        
        view.addSubview(bottomControlView)
        bottomControlView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 5, bottom: -120, right: 5), size: .init(width: 0, height: 70))
        bottomControlView.addSubview(blurView)
        blurView.fillSuperview()
        bottomControlView.addSubview(bottomStackView)
        bottomStackView.anchor(top: bottomControlView.topAnchor, leading: bottomControlView.leadingAnchor, bottom: bottomControlView.bottomAnchor, trailing: bottomControlView.trailingAnchor, padding: .init(top: 0, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING))
        
        bottomTitleLabel.text = viewModel.category.getTitle()
        guard let urlString = viewModel.category.getImageUrl(), let url = URL(string: urlString) else { return }
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.bottomImageView.image = image?.withRenderingMode(.alwaysOriginal)
        }
        
    }
    
    //MARK: - Methods
    private func hideBottomControlView() {
        navigationItem.titleView?.isHidden = false
        if bottomControlView.transform != .identity {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: { [weak self] in
                self?.bottomControlView.transform = .identity
            })
        }
    }
    
    private func showBottomControlView() {
        navigationItem.titleView?.isHidden = true
        if bottomControlView.transform == .identity {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: { [weak self] in
                self?.bottomControlView.transform = .init(translationX: 0, y: -125)
            })
        }
    }
    
    //MARK: - Delegation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.7, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.bottomControlView.transform = .init(translationX: 0, y: -125)
        })

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToViewModel() {
        
        addContentButton.rx.tap.map { (_) -> Void in
            return ()
            }.bind(to: viewModel.requestedAddContent).disposed(by: disposeBag)

        backButton.rx.tap.map { (_) -> Void in
            return ()
        }.bind(to: viewModel.goBack).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesFromViewModel() {
        viewModel.collectionViewScrolled.subscribe (onNext: { [weak self] (_) in

            guard let firstCellBottom = self?.collectionView.cellForItem(at: IndexPath(item: 1, section: 0))?.rectCorrespondingToWindow.maxY else { return }
            guard let navBottom = self?.navigationController?.navigationBar.rectCorrespondingToWindow.maxY  else { return }
            
            if navBottom >= firstCellBottom {
                self?.hideBottomControlView()
            } else {
                self?.showBottomControlView()
            }
            
        }).disposed(by: disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
