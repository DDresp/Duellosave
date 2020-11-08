//
//  DarkSquaredButton.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class DarkSquaredButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ULTRADARKCOLOR
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
