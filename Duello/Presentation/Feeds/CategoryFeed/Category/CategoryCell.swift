//
//  CategoryCell.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryCell: UICollectionViewCell {

    //MARK: - Displayer
    var displayer: CategoryDisplayer?

    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = EXTREMELIGHTGRAYCOLOR
        setupLayout()
    }

    //MARK: - Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DARKGRAYCOLOR
        label.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = STANDARDSPACING
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(oneTapGesture)
        return stackView
    }()

    //MARK: - Interactions
    private let oneTapGesture: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.numberOfTapsRequired = 1
        return gestureRecognizer
    }()
    
    //MARK: - Layout
    
    private func setupLayout() {
        contentView.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: STANDARDSPACING, left: STANDARDSPACING, bottom: STANDARDSPACING, right: STANDARDSPACING), size: .zero)
    }

    //MARK: - Methods
    
    func fit() {
        guard let displayer = displayer else { return }

        setupText(displayer: displayer)
        layoutIfNeeded()
    }

    func configure() {
        disposeBag = DisposeBag()
        guard let displayer = self.displayer else { return }
        
        layoutIfNeeded()
        
        setupText(displayer: displayer)

        layoutIfNeeded()

        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()

    }

    private func setupText(displayer: CategoryDisplayer) {
        titleLabel.text = displayer.title
        descriptionLabel.text = displayer.description
    }

    //MARK: - Reactive
    var disposeBag = DisposeBag()

    func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        oneTapGesture.rx.event.map { (_) -> Void in
            return ()
            }.bind(to: displayer.tapped).disposed(by: disposeBag)
    }

    func setupBindablesFromDisplayer() {

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

