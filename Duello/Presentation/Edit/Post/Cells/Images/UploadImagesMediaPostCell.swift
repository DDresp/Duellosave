//
//  UploadImagesMediaPostCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

class UploadImagesMediaPostCell: UITableViewCell {
    
    //MARK: - Displayer
    var displayer: UploadImagesPostDisplayer? {
        didSet {
            imagesSlider.displayer = displayer?.imagesSliderDisplayer
        }
    }
    
    //MARK: - Variables
    weak var parentViewController: UIViewController?
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = EXTREMELIGHTGRAYCOLOR
        clipsToBounds = true
        setupLayout()
        
    }
    
    //MARK: - Views
    let imagesSlider = ImagesSlider()
    
    //MARK: - Layout
    private func setupLayout() {
        addSubview(imagesSlider)
        imagesSlider.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
