//
//  UploadPostDescriptionCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class UploadDescriptionCell: UITableViewCell {
    
    //MARK: - Displayer
    var displayer: UploadDescriptionDisplayer? {
        didSet {
            setupBindablesToDisplayer()
            setupBindablesFromDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleLabel))
        placeholderLabel.addGestureRecognizer(tapgesture)
        
    }
    
    //MARK: - Views
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = WHITE
        label.font = UIFont.mediumCustomFont(size: SMALLFONTSIZE)
        label.backgroundColor = UIColor.clear
        label.text = "Add a description"
        label.textColor = GRAY
        label.isUserInteractionEnabled = true
        label.backgroundColor = .clear
        return label
    }()
    
    let textView: UITextView = {
        let textView = CustomTextView()
        textView.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        textView.textColor = LIGHT_GRAY
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    //MARK: - Interactions
    @objc func handleLabel() {
        textView.becomeFirstResponder()
    }
    
    //MARK: - Layout
    private func setupLayout() {
        contentView.backgroundColor = BLACK
        
        contentView.addSubview(textView)
        textView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING))
        textView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: nil, leading: textView.leadingAnchor, bottom: nil, trailing: nil)
        placeholderLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor).isActive = true
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        
        textView.rx.text.bind(to: displayer.rawDescription).disposed(by: disposeBag)
        textView.rx.didBeginEditing.bind(to: displayer.didBeginEditing).disposed(by: disposeBag)
        textView.rx.didEndEditing.bind(to: displayer.didEndEditing).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        guard let displayer = displayer else { return }
        
        displayer.description.subscribe(onNext: { [weak self] (text) in
            self?.textView.text = text //The description might have been changed in the viewModel (du to, for example, maxCharacter constraint)
        }).disposed(by: disposeBag)
        
        displayer.showPlaceHolderLabel.asObservable().bind(to: placeholderLabel.rx.isHidden).disposed(by: disposeBag)
        
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
