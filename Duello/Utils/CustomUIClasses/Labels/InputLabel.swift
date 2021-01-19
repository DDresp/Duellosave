//
//  InputLabel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class InputLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: STANDARDSPACING, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 1000, height: 44)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = WHITE
        font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        backgroundColor = UIColor.white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
