//
//  InputTextField.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class InputTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: STANDARDSPACING, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: STANDARDSPACING, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 1000, height: 44)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = LIGHT_GRAY
        autocorrectionType = .no
        font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        backgroundColor = BLACK
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
