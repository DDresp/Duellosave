//
//  CustomView.swift
//  Duello
//
//  Created by Darius Dresp on 1/19/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    var height: CGFloat = 25
    var width: CGFloat = 25
    
    convenience init(width: CGFloat, height: CGFloat) {
        self.init()
        self.width = width
        self.height = height
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: width, height: height)
    }
    
}
