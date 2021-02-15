//
//  SingleImagePostCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import UICircularProgressRing
import SDWebImage

class SingleImagePostCell: PostCell {
    
    //MARK: Displayer
    var singeImageDisplayer: SingleImagePostDisplayer? {
        return displayer as? SingleImagePostDisplayer
    }
    
    //MARK: - Views
    override var mediaView: UIView {
        get {
            return singleImageView
        }
        set {}
    }
    
    private lazy var singleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = DARK_GRAY
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(doubleTapGesture)
        return imageView
    }()
    
    //MARK: - Reactive
    
    override func setupBindablesFromDisplayer() {
        super.setupBindablesFromDisplayer()
        
        singeImageDisplayer?.imageUrl.subscribe(onNext: { [weak self] (imageUrl) in
            guard let imageUrl = imageUrl else {
                self?.singleImageView.isHidden = true
                return }
            self?.singleImageView.isHidden = false
            self?.singleImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            self?.singleImageView.sd_setImage(with: imageUrl, completed: { (image, error, _, _) in
                if image == nil {
                    self?.singleImageView.image = #imageLiteral(resourceName: "noInternetIcon").withRenderingMode(.alwaysOriginal)
                }
            })
            
        }).disposed(by: disposeBag)
    }
}
