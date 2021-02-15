//
//  CategoryCell.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryCell: UICollectionViewCell {

    //MARK: - Displayer
    var displayer: CategoryDisplayer?

    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = DARK_GRAY
        setupLayout()
    }

    //MARK: - Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = WHITE
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = LIGHT_GRAY
        label.font = UIFont.lightCustomFont(size: VERYSMALLFONTSIZE)
        label.numberOfLines = 2
        return label
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = STANDARDSPACING
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    //MARK: - Layout
    
    private func setupLayout() {
        
        contentView.addSubview(coverImageView)
        coverImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .zero, size: .init(width: 0, height: frame.width))
        
        contentView.addSubview(stackView)
        stackView.anchor(top: coverImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: STANDARDSPACING, left: STANDARDSPACING, bottom: STANDARDSPACING, right: STANDARDSPACING), size: .zero)
        
    }

    //MARK: - Methods
    
    func fit() {
        guard let displayer = displayer else { return }

        setupText(displayer: displayer)
        layoutIfNeeded()
    }

    func configure() {
        disposeBag = DisposeBag()
        guard let displayer = self.displayer else { return }
        
        layoutIfNeeded()
        
        setupCoverImage(displayer: displayer)
        setupText(displayer: displayer)
        
        layoutIfNeeded()

        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()

    }
    
    private func setupCoverImage(displayer: CategoryDisplayer) {
        guard let urlString = displayer.imageUrl else {
            coverImageView.image = #imageLiteral(resourceName: "image5").withRenderingMode(.alwaysOriginal)
            return }
        guard let url = URL(string: urlString) else { return }
        coverImageView.sd_setImage(with: url)
    }

    private func setupText(displayer: CategoryDisplayer) {
        titleLabel.text = displayer.title
        descriptionLabel.text = displayer.description
    }

    //MARK: - Reactive
    var disposeBag = DisposeBag()

    func setupBindablesToDisplayer() {
    }

    func setupBindablesFromDisplayer() {

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

