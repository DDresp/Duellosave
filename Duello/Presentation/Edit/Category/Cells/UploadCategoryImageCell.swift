//
//  UploadCategoryImageCell.swift
//  Duello
//
//  Created by Darius Dresp on 1/21/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import SDWebImage

class UploadCategoryImageCell: UITableViewCell {
    
    //MARK: - Displayer
//    var displayer: EditUserHeaderDisplayer? {
//        didSet {
//            setupBindablesToDisplayer()
//            setupBindablesFromDisplayer()
//            setHeaderImage()
//        }
//    }
    var displayer: UploadCategoryDisplayer? {
        didSet {
            setupBindablesToDisplayer()
            setupBindablesFromDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    //MARK: - Views
    private let imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = DARK_GRAY
        button.setTitle("Select cover image", for: .normal)
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.imageView?.contentMode = .scaleToFill
        button.layer.borderWidth = 3
        button.layer.borderColor = DARK_GRAY.cgColor
        return button
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        contentView.backgroundColor = BLACK
        
        contentView.addSubview(imageButton)
        imageButton.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: STANDARDSPACING, left: STANDARDSPACING, bottom: STANDARDSPACING, right: STANDARDSPACING))
        
    }

    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()

    private func setupBindablesFromDisplayer() {
        guard let displayer = displayer else { return }
        imageButton.rx.tap.asDriver().drive(displayer.imageButtonTapped).disposed(by: disposeBag)
    }

    private func setupBindablesToDisplayer() {
        displayer?.image.asObservable().bind(to: imageButton.rx.image()).disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

