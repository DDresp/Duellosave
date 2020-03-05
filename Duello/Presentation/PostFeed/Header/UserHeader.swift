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
    var displayer: UserHeaderDisplayer?
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = DARKGRAYCOLOR
        setupLayout()
    }
    
    //MARK: - Views
    private let profileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = DARKGRAYCOLOR
        button.layer.cornerRadius = 160 / 2
        button.clipsToBounds = true
        button.layer.borderColor = VERYLIGHTGRAYCOLOR.cgColor
        button.layer.borderWidth = 3
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        label.textColor = VERYLIGHTGRAYCOLOR
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
        setupLayoutProfileImageButton()
        setupLayoutNameLabel()
        setupLayoutSocialMediaCollectionViewController()
        setupLayoutActivityIndicatorView()
        
    }
    
    private func setupLayoutLikePercentageView() {
        addSubview(likePercentageView)
        likePercentageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        likePercentageView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
    }
    
    private func setupLayoutProfileImageButton() {
        addSubview(profileImageButton)
        profileImageButton.anchor(top: likePercentageView.percentageLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: 160, height: 160))
        profileImageButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    private func setupLayoutNameLabel() {
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setupLayoutSocialMediaCollectionViewController() {
        addSubview(socialMediaCollectionViewController.view)
        socialMediaCollectionViewController.view.anchor(top: nameLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
    }
    
    private func setupLayoutActivityIndicatorView() {
        profileImageButton.addSubview(activityIndicatorView)
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
        setupLikeView(displayer: displayer)
        layoutIfNeeded()
        
        setupBindablesToDisplayer()
        
    }
    
    private func setupText(displayer: UserHeaderDisplayer) {
        nameLabel.text = displayer.userName
    }
    
    private func setupLikeView(displayer: UserHeaderDisplayer) {
        
        if let totalRate = displayer.totalRate, displayer.totalRateNeedsAnimation.value {
            likePercentageView.showLikeViewAnimation(percentage: totalRate, fromStart: false)
            displayer.totalRateNeedsAnimation.accept(false)
        } else if let totalRate = displayer.totalRate {
            likePercentageView.showLikeView(percentage: totalRate)
        }
    }
    
    private func setupProfileImage(displayer: UserHeaderDisplayer) {
        
        profileImageButton.setImage(nil, for: .normal)
        activityIndicatorView.startAnimating()
        if let imageUrl = displayer.imageUrl, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.activityIndicatorView.stopAnimating()
                self.profileImageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    private func setupSocialMedia(displayer: UserHeaderDisplayer) {
        
        if displayer.hasSocialMediaNames == true {
            socialMediaCollectionViewController.view.isHidden = false
            socialMediaCollectionViewController.displayer = displayer.socialMediaViewModel
        } else {
            socialMediaCollectionViewController.view.isHidden = true
        }
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        profileImageButton.rx.tap.bind(to: displayer.imageTapped).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
