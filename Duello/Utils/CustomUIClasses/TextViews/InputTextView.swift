//
//  InputTextView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class InputTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
        textContainerInset = .init(top: 12, left: STANDARDSPACING - 4, bottom: 15, right: STANDARDSPACING)
        font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        backgroundColor = .white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
