//
//  UploadSingleImagePostCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class UploadSingleImageMediaPostCell: UITableViewCell {
    
    //MARK: - Displayer
    var displayer: UploadSingleImagePostDisplayer? {
        didSet {
            
            if let image = displayer?.image {
                singleImageView.image = image.withAlignmentRectInsets(.init(top: 0, left: 0, bottom: -15, right: 0))
            } else if let imageUrl = displayer?.imageUrl {
                singleImageView.sd_setImage(with: imageUrl)
            }
            
        }
    }
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        backgroundColor = EXTREMELIGHTGRAYCOLOR
        addSubview(singleImageView)
        singleImageView.fillSuperview()
        
    }
    
    //MARK: - Views
    private let singleImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
