//
//  InteractiveHoshiTextField.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit
import TextFieldEffects

class InteractiveHoshiTextField: HoshiTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeholderFontScale = 1
        placeholderColor = DARK_GRAY
        font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        textColor = BLACK
        borderActiveColor = BLACK
        borderInactiveColor = BLACK
        autocorrectionType = UITextAutocorrectionType.no
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
