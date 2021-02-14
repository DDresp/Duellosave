//
//  CategoryHeader.swift
//  Duello
//
//  Created by Darius Dresp on 4/9/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import SDWebImage
import RxSwift
import RxCocoa
import JGProgressHUD

class CategoryHeader: UICollectionReusableView {
    
    //MARK: - Displayer
    var displayer: CategoryHeaderViewModel?
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = BLACK
        setupLayout()
    }
    
    //MARK: - Views
    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = BLACK
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 4
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        label.textColor = WHITE
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var favoriteCV: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 0.5
        view.layer.borderColor = LIGHT_GRAY.cgColor
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(oneTapGesture)
        return view
    }()
    
    private let favoriteIcon: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private let favoriteLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = LIGHT_GRAY
        label.font = UIFont.mediumCustomFont(size: VERYSMALLFONTSIZE)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        label.textColor = LIGHT_GRAY
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - User Interaction
    let oneTapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        
        addSubview(coverImageView)
        coverImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: STANDARDSPACING, left: STANDARDSPACING, bottom: 0, right: 0), size: .init(width: frame.width * 1/3, height: frame.width * 1/3))
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, leading: coverImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: STANDARDSPACING, left: STANDARDSPACING, bottom: 0, right: 0))
        
        addSubview(favoriteCV)
        favoriteCV.anchor(top: nil, leading: coverImageView.trailingAnchor, bottom: coverImageView.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: STANDARDSPACING, bottom: STANDARDSPACING, right: STANDARDSPACING), size: .init(width: 0, height: 28))
        
        favoriteCV.addSubview(favoriteIcon)
        favoriteIcon.anchor(top: nil, leading: favoriteCV.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: STANDARDSPACING, bottom: 0, right: 0), size: .init(width: 18, height: 18))
        favoriteIcon.centerYAnchor.constraint(equalTo: favoriteCV.centerYAnchor).isActive = true
        
        favoriteCV.addSubview(favoriteLabel)
        favoriteLabel.anchor(top: favoriteCV.topAnchor, leading: favoriteIcon.trailingAnchor, bottom: favoriteCV.bottomAnchor, trailing: favoriteCV.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: STANDARDSPACING))
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: coverImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: STANDARDSPACING, left: STANDARDSPACING, bottom: STANDARDSPACING, right: STANDARDSPACING))

    }
    
    
    //MARK: - Methods
    func fit() {
        guard let displayer = displayer else { return }
        setupText(displayer: displayer)
        layoutIfNeeded()
    }
    
    func configure() {
        disposeBag = DisposeBag()
        guard let displayer = displayer else { return }
        setupImageView(displayer: displayer)
        setupText(displayer: displayer)
        layoutIfNeeded()
        
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
}
    
    private func setupImageView(displayer: CategoryHeaderViewModel) {
        guard let urlString = displayer.imageUrl else { return }
        guard let url = URL(string: urlString) else { return }
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.coverImageView.image = image?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    private func setupText(displayer: CategoryHeaderViewModel) {
        nameLabel.text = displayer.title
        descriptionLabel.text = displayer.description
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        oneTapGesture.rx.event.map { (_) -> Void in
            return ()
        }.bind(to: displayer.tappedFavorite).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        
        displayer?.isFavorite.subscribe(onNext: { [weak self] (isFavorite) in
            guard let isFavorite = isFavorite else { return }
            if isFavorite {

                let image = UIImage(named: "favoriteSelectedIcon")?.withRenderingMode(.alwaysTemplate)
                self?.favoriteIcon.image = image
                self?.favoriteIcon.tintColor = .yellow
                
                self?.favoriteLabel.text = "Added to favorites"

            } else {
                
                let image = UIImage(named: "favoriteUnselectedIcon")?.withRenderingMode(.alwaysTemplate)
                self?.favoriteIcon.image = image
                self?.favoriteIcon.tintColor = WHITE
                
                self?.favoriteLabel.text = "Add to favorites"
                
            }
            }).disposed(by: disposeBag)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

