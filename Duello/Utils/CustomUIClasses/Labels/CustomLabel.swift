//
//  CustomLabel.swift
//  Duello
//
//  Created by Darius Dresp on 1/20/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    var width: CGFloat?
    var height: CGFloat?
    
    convenience init(width: CGFloat?, height: CGFloat?) {
        self.init()
        self.width = width
        self.height = height
    }
    
    override var intrinsicContentSize: CGSize {
        guard let width = width, let height = height else { return super.intrinsicContentSize }
        return .init(width: width, height: height)
    }
    
}
