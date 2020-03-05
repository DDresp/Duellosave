//
//  UIFont+Extension.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

extension UIFont {
    
    //Creating CustomFonts
    static func boldCustomFont(size: CGFloat) -> UIFont {
        return UIFont(name: BOLDFONT, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func mediumCustomFont(size: CGFloat) -> UIFont {
        return UIFont(name: MEDIUMFONT, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func lightCustomFont(size: CGFloat) -> UIFont {
        return UIFont(name: LIGHTFONT, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func obliqueCustomFont(size: CGFloat) -> UIFont {
        return UIFont(name: OBLIQUEFONT, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
}
