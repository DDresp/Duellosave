//
//  StaticTextField.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class StaticTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font =  UIFont.lightCustomFont(size: SMALLFONTSIZE)
        isUserInteractionEnabled = false
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
