//
//  LargeIconImageView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class LargeIconImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 38, height: 38)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        backgroundColor = BLACK
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LargeIconImageViewContainer: UIView {
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 15 + STANDARDSPACING, height: 15)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        backgroundColor = BLACK
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
