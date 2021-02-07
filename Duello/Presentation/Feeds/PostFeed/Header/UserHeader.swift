//
//  UserHeader.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import SDWebImage
import RxSwift
import RxCocoa
import JGProgressHUD

class UserHeader: UICollectionReusableView {
    
    //MARK: - Displayer
    var displayer: UserHeaderViewModel?
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = BLACK
        setupLayout()
    }
    
    //MARK: - Views
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = BLACK
        iv.layer.cornerRadius = 160 / 2
        iv.clipsToBounds = true
        iv.layer.borderColor = DARK_GRAY.cgColor
        iv.layer.borderWidth = 3
        return iv
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        label.textColor = LIGHT_GRAY
        label.numberOfLines = 1
        return label
    }()
    
    private let likePercentageView: LikePercentageView = {
        let view = LikePercentageView()
        return view
    }()
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    
    private lazy var socialMediaCollectionViewController = SocialMediaCollectionViewController()
    
    //MARK: - Layout
    private func setupLayout() {
        setupLayoutLikePercentageView()
        setupLayoutProfileImageView()
        setupLayoutNameLabel()
        setupLayoutSocialMediaCollectionViewController()
        setupLayoutActivityIndicatorView()
        
    }
    
    private func setupLayoutLikePercentageView() {
        addSubview(likePercentageView)
        likePercentageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        likePercentageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
    }
    
    private func setupLayoutProfileImageView() {
        addSubview(profileImageView)
        profileImageView.anchor(top: likePercentageView.percentageLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: 160, height: 160))
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    private func setupLayoutNameLabel() {
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 20))
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setupLayoutSocialMediaCollectionViewController() {
        addSubview(socialMediaCollectionViewController.view)
        socialMediaCollectionViewController.view.anchor(top: nameLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
    }
    
    private func setupLayoutActivityIndicatorView() {
        profileImageView.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        activityIndicatorView.startAnimating()
    }
    
    //MARK: - Methods
    func fit() {
        guard let displayer = displayer else { return }
        setupText(displayer: displayer)
        setupSocialMedia(displayer: displayer)
        layoutIfNeeded()
    }
    
    func configure() {
        
        disposeBag = DisposeBag()
        guard let displayer = displayer else { return }
        
        setupProfileImage(displayer: displayer)
        setupText(displayer: displayer)
        setupSocialMedia(displayer: displayer)
        layoutIfNeeded()

        setupBindablesFromDisplayer()
        
    }
    
    private func setupText(displayer: UserHeaderViewModel) {
        nameLabel.text = displayer.userName
    }
    
    private func setupProfileImage(displayer: UserHeaderViewModel) {

        activityIndicatorView.startAnimating()
        if let imageUrl = displayer.imageUrl, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.activityIndicatorView.stopAnimating()
                self.profileImageView.image = image?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    private func setupSocialMedia(displayer: UserHeaderViewModel) {
        
        if displayer.hasSocialMediaNames == true {
            socialMediaCollectionViewController.view.isHidden = false
            socialMediaCollectionViewController.displayer = displayer.socialMediaDisplayer
        } else {
            socialMediaCollectionViewController.view.isHidden = true
        }
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesFromDisplayer() {
        
        displayer?.animateScore.subscribe(onNext: { [weak self] (_) in
            guard let score = self?.displayer?.score else { return }
            self?.likePercentageView.showLikeViewAnimation(percentage: score)
        }).disposed(by: disposeBag)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
