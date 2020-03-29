//
//  FooterLoadingCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class FooterLoadingCell: UICollectionReusableView {
    
    //MARK: - Displayer
    var displayer: PostCollectionDisplayer? {
        
        didSet {
            
            if displayer?.hasNoPosts == true {
                activityIndicator.stopAnimating()
                endView.isHidden = true
            }   else if displayer?.finished == true {
                activityIndicator.stopAnimating()
                endView.isHidden = false
            } else {
                activityIndicator.startAnimating()
                endView.isHidden = true
            }
            
        }
    }
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = VERYLIGHTGRAYCOLOR
        setupLayout()
    }
    
    //MARK: - Views
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    private let endView: UIView = {
        let view = UIView()
        view.backgroundColor = DARKGRAYCOLOR
        let label = UILabel()
        label.text = "END"
        label.textColor = EXTREMELIGHTGRAYCOLOR
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        label.textAlignment = .center
        view.addSubview(label)
        label.fillSuperview()
        view.isHidden = true
        return view
    }()
    
    //MARK: - Layout
    
    private func setupLayout() {
        
        addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        
        addSubview(endView)
        endView.fillSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
