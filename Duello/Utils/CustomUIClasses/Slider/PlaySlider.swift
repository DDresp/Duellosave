//
//  CustomSlider.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class PlaySlider: UISlider {
    
    func changeProgress(progress: Float, animated: Bool) {
        setValue(progress, animated: false)
        progressView.setProgress(progress, animated: animated)
    }
    
    private let progressView = UIProgressView(progressViewStyle: .default)
    
    override init (frame: CGRect) {
         super.init(frame: frame)
     }

     convenience init () {
         self.init(frame: .zero)
         setup()
     }
    
    
    func setup() {
        
        backgroundColor = .clear
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear
        setThumbImage(UIImage(), for: .normal)
        
        progressView.backgroundColor = .clear
        progressView.isUserInteractionEnabled = false
        progressView.progress = 0.0
        progressView.progressTintColor = .gray
        progressView.trackTintColor = DARKGRAYCOLOR
        
        addSubview(progressView)
        progressView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
