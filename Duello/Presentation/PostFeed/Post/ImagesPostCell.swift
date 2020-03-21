//
//  ImagesPostCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ImagesPostCell: PostCell<ImagesPostViewModel> {
    
    //MARK: - Views
    private lazy var imagesSlider: ImagesSlider = {
        let slider = ImagesSlider()
        slider.addGestureRecognizer(doubleTapGesture)
        return slider
    }()
    
    override var mediaView: UIView {
        get {
            return imagesSlider
        }
        set {}
    }
    
    //MARK: - Methods
    override func configure() {
        super.configure()
        imagesSlider.displayer = displayer?.imagesSliderDisplayer
    }
}
