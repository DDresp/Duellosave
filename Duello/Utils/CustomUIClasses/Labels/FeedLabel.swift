//
//  FeedLabel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class FeedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING)
        super.drawText(in: rect.inset(by: insets))
    }
    
}
