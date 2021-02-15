//
//  ImageViewController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController {
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    //MARK: - Views
    let imageView = UIImageView()
    
    //MARK: - Methods
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    func setImageUrl(imageUrl: URL) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        imageView.sd_setImage(with: imageUrl) { [weak self] (image, error, _, _) in
            if image == nil {
                self?.imageView.image  = #imageLiteral(resourceName: "noInternetIcon").withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
}
