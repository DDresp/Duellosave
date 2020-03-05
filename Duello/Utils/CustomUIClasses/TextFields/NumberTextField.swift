//
//  NumberTextField.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class NumberTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        autocorrectionType = .no
        keyboardType = .phonePad
        backgroundColor = .white
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 10000, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y:  bounds.origin.y + 8, width: bounds.size.width - 20, height: bounds.size.height - 16)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
}
