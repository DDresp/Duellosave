//
//  LikePercentageView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class LikePercentageView: UIView {
    
    //MARK: - Variables
    lazy var initialLabelWidth: CGFloat = {
        let sizeLabel = UILabel()
        sizeLabel.text = "0"
        sizeLabel.font = percentageLabel.font
        sizeLabel.sizeToFit()
        return sizeLabel.frame.width
    }()
    
    var likeWidthConstraint: NSLayoutConstraint?
    var isAnimating = false
    
    //MARK: - Setup
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    //MARK: - Views
    private let shadowBarView: UIView = {
        let view = UIView()
        view.backgroundColor = VERYLIGHTGRAYCOLOR
        view.clipsToBounds = true
        return view
    }()
    
    private let ratingBarView: UIView = {
        let view = UIView()
        view.backgroundColor = VERYLIGHTGRAYCOLOR
        view.clipsToBounds = true
        return view
    }()
    
    private let likeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = GREENCOLOR
        view.layer.borderColor = UIColor.black.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let stickView: UIView = {
        let stick = UIView()
        stick.backgroundColor = STRONGFONTCOLOR
        stick.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stick.widthAnchor.constraint(equalToConstant: 2).isActive = true
        stick.isHidden = true
        return stick
    }()
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: VERYSMALLFONTSIZE)
        label.text = "0"
        label.textColor = LIGHTFONTCOLOR
        label.isHidden = true
        return label
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        setupLayoutShadowBarView()
        setupLayoutRatingBarView()
        setupLayoutLikeBarView()
        setupLayoutLikePercentageView()
    }
    
    private func setupLayoutShadowBarView() {
        addSubview(shadowBarView)
        shadowBarView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))

    }
    
    private func setupLayoutRatingBarView() {
        shadowBarView.addSubview(ratingBarView)
        ratingBarView.anchor(top: shadowBarView.topAnchor, leading: shadowBarView.leadingAnchor, bottom: shadowBarView.bottomAnchor, trailing: shadowBarView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0.5, right: 0))
    }
    
    private func setupLayoutLikeBarView() {
        ratingBarView.addSubview(likeBarView)
        likeBarView.anchor(top: ratingBarView.topAnchor, leading: nil, bottom: ratingBarView.bottomAnchor, trailing: nil)
        likeWidthConstraint = likeBarView.widthAnchor.constraint(equalToConstant: 0)
        likeWidthConstraint?.isActive = true
    }
    
    private func setupLayoutLikePercentageView() {
        
        addSubview(stickView)
        stickView.anchor(top: ratingBarView.bottomAnchor, leading: ratingBarView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: -1, bottom: 0, right: 0))
        
        addSubview(percentageLabel)
        percentageLabel.anchor(top: stickView.bottomAnchor, leading: ratingBarView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 1, left: -initialLabelWidth/2, bottom: 0, right: 0))
        
    }
    
    //MARK: - Methods
    func calculateAddedLabelWidth(percentage: Double) -> CGFloat {
        let sizeLabel = UILabel()
        sizeLabel.text = "\(Int((percentage) * 100))"
        sizeLabel.font = percentageLabel.font
        sizeLabel.sizeToFit()
        return sizeLabel.frame.width - initialLabelWidth
    }
    
    private func setNewLikeViewWidth(for percentage: Double) {
        let newLikeWidth = (self.ratingBarView.frame.width) * (CGFloat(percentage))
        likeWidthConstraint?.constant = newLikeWidth
    }

    func showLikeViewAnimation(percentage: Double, duration: Double = 1, fromStart: Bool = false, fromPercentage: Double? = nil) {
        if isAnimating { return }
        
        self.stickView.isHidden = true
        self.percentageLabel.isHidden = true
        if fromStart {
            likeWidthConstraint?.constant = 0
            layoutIfNeeded()
        }
        setNewLikeViewWidth(for: percentage)
        isAnimating = true
        UIView.animate(withDuration: duration, delay: 0, options: [], animations: { [weak self] () in
            self?.layoutIfNeeded()
        }) { [weak self] (finished) in
            self?.setItemsAfterShowingNewLikeView(for: percentage)
            self?.isAnimating = false
        }
    }
    
    func showLikeView(percentage: Double) {
        self.layoutIfNeeded()
        setNewLikeViewWidth(for: percentage)
        self.layoutIfNeeded()
        setItemsAfterShowingNewLikeView(for: percentage)
        
    }
    
    private func setItemsAfterShowingNewLikeView(for percentage: Double) {

        let filledWidth = self.likeBarView.frame.width
        let totalWidth = self.ratingBarView.frame.width
        let percentageDisplay = Double(filledWidth)/Double(totalWidth) * 100

        self.percentageLabel.text = "\(Int(round(percentageDisplay)))"
        self.percentageLabel.sizeToFit()
        self.stickView.transform = CGAffineTransform(translationX: filledWidth, y: 0)

        var likePercentageStackViewCenter = filledWidth - calculateAddedLabelWidth(percentage: percentage) / 2
        let percentageLabelMaxX = totalWidth - self.percentageLabel.frame.width
        let percentagelabelMinX: CGFloat = self.initialLabelWidth/2
        likePercentageStackViewCenter = max(likePercentageStackViewCenter, percentagelabelMinX)
        likePercentageStackViewCenter = min(likePercentageStackViewCenter, percentageLabelMaxX)
        self.percentageLabel.transform = CGAffineTransform(translationX: likePercentageStackViewCenter, y: 0)
        
        self.stickView.isHidden = false
        self.percentageLabel.isHidden = false
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
