//
//  EmptyCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class EmptyCell: UICollectionViewCell {
    
    //MARK: - Displayer
    var displayer: PostCollectionDisplayer? {
        
        didSet {
            if displayer?.hasNoPosts == true {
                isHidden = false
            } else {
                isHidden = true
            }
        }
    }
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        isHidden = true
        backgroundColor = VERYLIGHTGRAYCOLOR
    }
    
    //MARK: - Views
    let label: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Welcome to Duello\n", attributes: [NSAttributedString.Key.font : UIFont.boldCustomFont(size: LARGEFONTSIZE), NSAttributedString.Key.foregroundColor: DARKGRAYCOLOR])
        let nextAttributedString = NSAttributedString(string: "You haven't created any posts, yet", attributes: [NSAttributedString.Key.font: UIFont.mediumCustomFont(size: MEDIUMFONTSIZE), NSAttributedString.Key.foregroundColor: LIGHTGRAYCOLOR])
        attributedString.append(nextAttributedString)
        label.attributedText = attributedString
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(label)
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
