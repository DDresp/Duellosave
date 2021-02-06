//
//  SocialMediaCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class SocialMediaCell: UICollectionViewCell {
    
    //MARK: - Displayer
    var displayer: SocialMediaItemDisplayer? {
        didSet {
            
            guard let displayer = displayer else { return }
            nameLabel.text = displayer.socialMediaName
            iconImageView.image = UIImage(named: displayer.iconName)?.withRenderingMode(.alwaysOriginal)
            nameLabel.font = displayer.hasLink ? UIFont.boldCustomFont(size: SMALLFONTSIZE) : UIFont.lightCustomFont(size: SMALLFONTSIZE)
            nameLabel.textColor = displayer.isDarkMode ? WHITE : LIGHT_GRAY
            
        }
    }
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupLayout()
        
    }
    
    //MARK: - Views
    private let imageViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let iconImageView: SmallIconImageView = {
        let imageView = SmallIconImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        label.textColor = LIGHT_GRAY
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var socialMediaNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageViewContainer, nameLabel])
        stackView.spacing = 3
        return stackView
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        addSubview(socialMediaNameStackView)
        socialMediaNameStackView.fillSuperview()
        
        imageViewContainer.addSubview(iconImageView)
        iconImageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
