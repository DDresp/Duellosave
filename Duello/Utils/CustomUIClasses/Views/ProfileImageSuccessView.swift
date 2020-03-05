//
//  ProfileImageSuccessView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit
import JGProgressHUD

class ProfileImageSuccessView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        addSubview(blurView)
        blurView.fillSuperview()
        
        let progressHud = JGProgressHUD.init(style: .dark)
        progressHud.indicatorView = JGProgressHUDSuccessIndicatorView()
        progressHud.show(in: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
