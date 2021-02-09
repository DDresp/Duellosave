//
//  EllipsisButton.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class EllipsisButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView?.contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 22, height: 22)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EllipsisButtonContainer: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 50)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
