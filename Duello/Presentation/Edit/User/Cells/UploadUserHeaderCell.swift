//
//  UploadUserHeaderCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import SDWebImage

class UploadUserHeaderCell: UITableViewCell {
    
    //MARK: - Displayer
    var displayer: UploadUserHeaderDisplayer? {
        didSet {
            setupBindablesToDisplayer()
            setupBindablesFromDisplayer()
            setHeaderImage()
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
        button.backgroundColor = VERYLIGHTGRAYCOLOR
        button.layer.cornerRadius = 190 / 2
        button.setTitle("Select Photo", for: .normal)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleToFill
        button.layer.borderWidth = 3
        button.layer.borderColor = VERYLIGHTGRAYCOLOR.cgColor
        return button
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        backgroundColor = DARKGRAYCOLOR
        
        addSubview(imageButton)
        imageButton.centerInSuperview(size: .init(width: 190, height: 190))
        
    }
    
    //MARK: - Methods
    private func setHeaderImage() {
        guard let displayer = displayer else { return }
        
        if let image = displayer.image.value {
            imageButton.setImage(image, for: .normal)
        }
        else if let imageUrl = displayer.initialImageUrl, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { [weak self] (image, _, _, _, _, _) in
                self?.imageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }

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
