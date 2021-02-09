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
    var insets: UIEdgeInsets?
    
    
    convenience init(width: CGFloat?, height: CGFloat?, insets: UIEdgeInsets? = nil) {
        self.init()
        self.width = width
        self.height = height
        self.insets = insets
    }
    
    override var intrinsicContentSize: CGSize {
        guard let width = width, let height = height else { return super.intrinsicContentSize }
        return .init(width: width, height: height)
    }
    
    override func drawText(in rect: CGRect) {
        guard let insets = insets else { return super.drawText(in: rect) }
        super.drawText(in: rect.inset(by: insets))
    }
    
}
