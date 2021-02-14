//
//  CustomTextField.swift
//  Duello
//
//  Created by Darius Dresp on 1/19/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    var width: CGFloat = 1000
    var height: CGFloat = 44
    
    convenience init(width: CGFloat?, height: CGFloat?) {
        self.init()
        
        if let width = width {
            self.width = width
        }
        
        if let height = height {
            self.height = height
        }

    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: width, height: height)
    }
    
}

