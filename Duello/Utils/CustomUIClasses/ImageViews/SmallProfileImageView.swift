//
//  SmallProfileImageView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class SmallProfileImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 30, height: 30)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentMode = .scaleToFill
        layer.borderColor = GRAY.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 30 / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SmallProfileImageViewContainer: UIView {
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 30, height: 30)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        backgroundColor = .clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
