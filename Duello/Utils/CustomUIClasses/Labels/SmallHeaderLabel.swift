//
//  SmallHeaderLabel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class SmallHeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        textColor = STRONGFONTCOLOR
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: STANDARDSPACING, dy: 0))
    }
    
}
