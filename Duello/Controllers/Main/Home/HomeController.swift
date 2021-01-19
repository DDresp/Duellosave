//
//  HomeController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift
import JGProgressHUD
import SDWebImage

class HomeController: PostCollectionMasterViewController {
    
    //MARK: - ViewModel
    var viewModel: HomeViewModel {
        return displayer as! HomeViewModel
    }
    
    //MARK: - Setup
    init(viewModel: HomeViewModel) {
        super.init(displayer: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewLayout()
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
    }

    //MARK: - Views
    private let profileImageView: SmallProfileImageView = {
        let iv = SmallProfileImageView(frame: .zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "settingsIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = LIGHT_GRAY
        return button
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = WHITE
        label.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionView: PostCollectionView = {
        let collectionView = PostCollectionView(displayer: viewModel.homeCollectionViewModel)
        return collectionView
    }()
    
    //MARK: - Layout
    private func setupCollectionViewLayout() {
        layoutSettingsButton()
        layoutProfileImageView()
        layoutNameLabel()
        layoutCollectionView()
    }
    
    private func layoutSettingsButton() {
        view.addSubview(settingsButton)
        settingsButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: STANDARDSPACING, left: 0, bottom: 0, right: STANDARDSPACING), size: .init(width: 25, height: 25))
    }
    
    private func layoutNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor, constant: 0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.text = viewModel.user.value?.getUserName()
    }
    
    private func layoutProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: STANDARDSPACING).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor, constant: 0).isActive = true
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(top: settingsButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: STANDARDSPACING, left: 0, bottom: 0, right: 0))
    }
    
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromDisplayer() {
        
        viewModel.user.subscribe(onNext: { [weak self] (user) in
            guard let self = self else { return }
            guard let user = user else { return }
            self.nameLabel.text = user.getUserName()
            guard let imageUrl = URL(string: user.getImageUrl()) else { return }
            SDWebImageManager.shared.loadImage(with: imageUrl, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.profileImageView.image = image?.withRenderingMode(.alwaysOriginal)
            }
        }).disposed(by: disposeBag)
        
   }


    private func setupBindablesToDisplayer() {
        settingsButton.rx.tap.asObservable().bind(to: viewModel.settingsTapped).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
