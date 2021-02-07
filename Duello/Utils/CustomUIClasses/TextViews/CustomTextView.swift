//
//  CustomTextView.swift
//  Duello
//
//  Created by Darius Dresp on 1/20/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        textContainer.lineFragmentPadding = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
