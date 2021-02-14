//
//  DarkSquaredButton.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    enum Style {
        case dark
        case light
    }
    
    var style: Style?
    var width: CGFloat = 80
    var height: CGFloat = 35
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(style: Style?, width: CGFloat?, height: CGFloat?) {
        self.init(type: .system)
        self.style = style
        if let width = width {
            self.width = width
        }
        
        if let height = height {
            self.height = height
        }

        setupStyle()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    private func setupStyle() {
        
        guard let style = style else { return }
        
        if style == .dark {
            backgroundColor = DARK_GRAY
            setTitleColor(WHITE, for: .normal)
            titleLabel?.font = UIFont.boldCustomFont(size: VERYSMALLFONTSIZE)
            layer.cornerRadius = 5
            clipsToBounds = true
        } else if style == .light {
            backgroundColor = GRAY
            setTitleColor(WHITE, for: .normal)
            titleLabel?.font = UIFont.boldCustomFont(size: VERYSMALLFONTSIZE)
            layer.cornerRadius = 5
            clipsToBounds = true
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
