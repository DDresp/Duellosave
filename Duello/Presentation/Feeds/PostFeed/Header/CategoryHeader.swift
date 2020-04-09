//
//  CategoryHeader.swift
//  Duello
//
//  Created by Darius Dresp on 4/9/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import SDWebImage
import RxSwift
import RxCocoa
import JGProgressHUD

class CategoryHeader: UICollectionReusableView {
    
    //MARK: - Displayer
    var displayer: CategoryHeaderViewModel?
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = DARKGRAYCOLOR
        setupLayout()
    }
    
    //MARK: - Views
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        label.textColor = VERYLIGHTGRAYCOLOR
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldCustomFont(size: MEDIUMFONTSIZE)
        label.textColor = VERYLIGHTGRAYCOLOR
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    
    //MARK: - Methods
    func fit() {
        guard let displayer = displayer else { return }
        setupText(displayer: displayer)
        layoutIfNeeded()
    }
    
    func configure() {
        disposeBag = DisposeBag()
        guard let displayer = displayer else { return }
        setupText(displayer: displayer)
        layoutIfNeeded()
    }
    
    private func setupText(displayer: CategoryHeaderViewModel) {
        nameLabel.text = displayer.title
        descriptionLabel.text = displayer.description
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

