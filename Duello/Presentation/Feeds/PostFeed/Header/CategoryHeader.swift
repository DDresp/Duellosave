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
        backgroundColor = ULTRADARKCOLOR
        setupLayout()
    }
    
    //MARK: - Views
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        label.textColor = LIGHTFONTCOLOR
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        label.textColor = LIGHTFONTCOLOR
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        
        addSubview(followButton)
        followButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 100, height: 60))
        followButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: followButton.topAnchor, trailing: trailingAnchor)
        
        
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
        setupText(displayer: displayer)
        layoutIfNeeded()
        
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
}
    
    private func setupText(displayer: CategoryHeaderViewModel) {
        nameLabel.text = displayer.title
        descriptionLabel.text = displayer.description
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        followButton.rx.tap.bind(to: displayer.tappedFollow).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        displayer?.isFollowed.subscribe(onNext: { [weak self] (isFollowed) in
            if isFollowed {
                self?.followButton.setTitle("unfollow", for: .normal)
                self?.followButton.backgroundColor = DARKCOLOR
                
            } else {
                self?.followButton.setTitle("follow", for: .normal)
                self?.followButton.backgroundColor = LIGHTBLUECOLOR
            }
            }).disposed(by: disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

